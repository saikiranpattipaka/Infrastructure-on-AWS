resource "aws_vpc" "terraform_vpc" {
  cidr_block = var.cidr
}

resource "aws_subnet" "terraform_subnet1" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "terraform_subnet2" {
  vpc_id     = aws_vpc.terraform_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "terraform_igw" {
  vpc_id = aws_vpc.terraform_vpc.id  
}

resource "aws_route_table" "terrraform_route_table" {
  vpc_id = aws_vpc.terraform_vpc.id
  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.terraform_igw.id  
   }
}

resource "aws_route_table_association" "terraform_route_table_association1" {
  subnet_id      = aws_subnet.terraform_subnet1.id
  route_table_id = aws_route_table.terrraform_route_table.id
}

resource "aws_route_table_association" "terraform_route_table_association2" {
  subnet_id      = aws_subnet.terraform_subnet2.id
  route_table_id = aws_route_table.terrraform_route_table.id
}

resource "aws_security_group" "terraform_security_group" {
  name = "terraform_security_group"
  vpc_id = aws_vpc.terraform_vpc.id

  ingress {
    description = "Allow HTTP inbound traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
      ingress {
    description = "Allow SSH inbound traffic"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "terraform_security_group"
    }
}

resource "aws_s3_bucket" "terraform_s3_bucket" {
  # Bucket name must be globally unique
  bucket = "terraform-s3-bucket-150320251819"
}
  
resource "aws_instance" "terraform_instance1" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform_security_group.id]
  subnet_id = aws_subnet.terraform_subnet1.id
  user_data = base64encode(file("userdata1.sh"))
}

resource "aws_instance" "terraform_instance2" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.terraform_security_group.id]
  subnet_id = aws_subnet.terraform_subnet2.id
  user_data = base64encode(file("userdata2.sh")) 
}

#create alb
resource "aws_lb" "terraform_lb" {
  name = "terraform-lb"
  internal = false
  load_balancer_type = "application"
  security_groups = [aws_security_group.terraform_security_group.id]
  subnets = [aws_subnet.terraform_subnet1.id, aws_subnet.terraform_subnet2.id]
}

resource "aws_lb_target_group" "terraform_target_group" {
  name = "terraform-target-group"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.terraform_vpc.id

    health_check {
        path = "/"
        port = "traffic-port"
    } 
}

resource "aws_lb_target_group_attachment" "terraform_target_group_attachment1" {
  target_group_arn = aws_lb_target_group.terraform_target_group.arn
  target_id = aws_instance.terraform_instance1.id
  port = 80
  
}

resource "aws_lb_target_group_attachment" "terraform_target_group_attachment2" {
  target_group_arn = aws_lb_target_group.terraform_target_group.arn
  target_id = aws_instance.terraform_instance2.id
  port = 80
  
}

resource "aws_lb_listener" "terraform_lb_listener" {
  load_balancer_arn = aws_lb.terraform_lb.arn
  port = 80
  protocol = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.terraform_target_group.arn
    type = "forward"
  }
}

output "loadbalancerdns" {
  value = aws_lb.terraform_lb.dns_name
  
}