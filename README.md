# Infrastructure on AWS using Terraform

### This Terraform configuration defines the setup of a scalable and secure AWS infrastructure. It includes the creation of a Virtual Private Cloud (VPC), multiple subnets, a security group, an S3 bucket, EC2 instances, an Application Load Balancer (ALB), and the necessary routing components. Below is an overview of each resource and its purpose:

![Project Screenshot](./images"C:\Users\saiki\Downloads\Infrastructure on AWS using Terraform.gif")

## VPC (Virtual Private Cloud):
### A VPC named terraform_vpc is created with a CIDR block defined by the variable cidr. The VPC serves as the isolated network for the resources that will be created.

## Subnets:
### Two subnets (terraform_subnet1 and terraform_subnet2) are created in different availability zones (us-east-1a and us-east-1b).
### Both subnets are configured to automatically assign public IPs to instances launched within them.

## Internet Gateway:
### An Internet Gateway (terraform_igw) is created and attached to the VPC to allow communication with the internet.

## Route Table:
### A route table (terraform_route_table) is defined with a route that forwards all outbound traffic (0.0.0.0/0) through the Internet Gateway, enabling internet access for instances in the subnets.

## Route Table Associations:
### The route table is associated with both subnets to ensure that instances in these subnets use the same route for outbound traffic.

## Security Group:
### A security group (terraform_security_group) is created with rules to allow:
### Inbound HTTP traffic on port 80.
### Inbound SSH traffic on port 22.
### All outbound traffic (0.0.0.0/0).
### This security group is applied to the EC2 instances to ensure they can be accessed as needed.

## S3 Bucket:
### An S3 bucket (terraform_s3_bucket) is created with a globally unique name. The bucket can be used to store data as needed.

## EC2 Instances:
### Two EC2 instances (terraform_instance1 and terraform_instance2) are provisioned using a specified AMI and the t2.micro instance type.
### Both instances are placed in separate subnets, with custom user data scripts (userdata1.sh and userdata2.sh) used to initialize the instances.

## Application Load Balancer (ALB):
### An ALB (terraform_lb) is created and placed in both subnets, making it accessible to clients from the internet.
### The ALB is set up with a listener on port 80, forwarding traffic to a target group.

## Target Group:
### A target group (terraform_target_group) is defined for the ALB. It uses HTTP protocol on port 80, with health checks configured to check the root path (/) of the instances.

## Target Group Attachments:
### Both EC2 instances are registered with the target group to ensure that the ALB can route traffic to them.

## Load Balancer Listener:
### A listener (terraform_lb_listener) is created for the ALB to listen on port 80. It is configured to forward traffic to the target group.

## Output:
### The DNS name of the ALB is outputted as loadbalancerdns, which can be used to access the load balancer.

## Key Benefits:
### Scalable Infrastructure: The setup allows for easy scaling by adding more EC2 instances to the target group behind the ALB.
### High Availability: By distributing instances across multiple subnets in different availability zones, the infrastructure ensures fault tolerance.
### Secure Access: The security group restricts inbound access while allowing necessary traffic such as HTTP and SSH.
### Automated Deployment: The use of Terraform enables infrastructure as code, making it easy to version control and reproduce the setup.



## Prerequisites
### AWS IAM account
### AWS Access Key
### AWS CLI Installed
### Refer [AWS CLI Doc] (https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

### Terraform Installed
### Refer [Terraform ] (https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)



### create Providers - Refer Terraform provider doc

# Terraform Commands
### 1.terraform init - Preparing your working directory for other commands
### 2.terraform validate - Check whether the configuration is valid
### 3.terraform plan - Show changes required by the current configuration
### 4.terraform apply - Create or update infrastructure
### You can use terraform apply -auto -approve to skip yes command
### 5.destroy - Destroy previously-cretaed infrastructure
### Refer [Terraform AWS doc] (https://registry.terraform.io/providers/hashicorp/aws/latest/docs)


### This project offers a simple yet flexible AWS infrastructure for hosting web applications with a load balancing mechanism and secure access control.
