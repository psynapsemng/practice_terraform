terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-west-3"
}

resource "aws_launch_configuration" "example" {
  image_id = "ami-0a89a7563fc68be84"
  instance_type = var.instancetype

  security_groups = [ aws_security_group.instance.id ]

  user_data = <<-EOF
              #!/bin/bash
              echo "Helllo,World" > index.html
              nuhup busybox httpd -f -p ${var.server_port} &
              EOF
  
  # Required when using a launch configuration with an auto scaling group.
  # https://www.terraform.io/docs/providers/aws/r/launch_configuration.html
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  
  min_size = 2
  max_size = 5

  tag {
    key = "Name"
    value = "terraform-asg-exemple"
    propagate_at_launch = true

  }
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default" {
  vpc_id = data.aws_vpc.default.id
}

resource "aws_instance" "web_server" {
  ami           = "ami-0a89a7563fc68be84"
  instance_type = var.instancetype
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "WebServerInstance"
  }
  root_block_device {
    delete_on_termination = true
  }
}

resource "aws_security_group" "instance" {

  name = var.security_group_name

  ingress {
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = var.server_port
    protocol = "tcp"
    to_port = var.server_port
  } 
}

resource "aws_eip" "lb" {
  instance = aws_instance.web_server.id
  vpc      = true
}

variable "security_group_name" {
  description = "The name of the security group"
  type = string
  default = "terraform-exemple-instance"
  
}

output "public-ip" {
  value = aws_instance.web_server.public_ip
  description = "The public IP of the instance"
}
