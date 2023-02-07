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

variable "security_group_name" {
  description = "The name of the security group"
  type = string
  default = "terraform-exemple-instance"
  
}

output "public-ip" {
  value = aws_instance.web_server.public_ip
  description = "The public IP of the instance"
}
