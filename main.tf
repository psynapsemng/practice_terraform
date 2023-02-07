provider "aws" {
  region     = "us-east-1"
  access_key = "XXX"
  secret_key = "XXX"
}

resource "aws_instance" "myec2" {
  ami           = "ami-0778521d914d23bc1"
  instance_type = "t2.micro"

  tags = {
    Name = "ec2-manh"
  }
  root_block_device {
    delete_on_termination = true
  }
}
