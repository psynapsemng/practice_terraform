provider "aws" {
  region     = "us-east-1"
  access_key = "AKIAQMZRBKZAZ33FOG3I"
  secret_key = "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"
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