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
  region  = "eu-west-3"
}

resource "aws_instance" "simple_web_server" {
  ami           = "ami-0a89a7563fc68be84"
  instance_type = "t2.micro"
  vpc_security_group_ids =  [aws_security_group.instance.id]

  user_data = <<-EOF
            #!bin/bash
            echo "Hello, World" > index.htm
            nohup busybox httpd -f -p 8080 &
            EOF

user_data_replace_on_change = true

  tags = {
    Name = "Simple-Webserver-exemple"
  }
}

resource "aws_security_group" "instance" {

    name = "open 8080 port"

    ingress {
        from_port   = 8080
        to_port     = 8080
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
