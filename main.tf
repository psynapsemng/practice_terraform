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

# Définit l'application load balancer

resource "aws_lb" "alb" {
  name = "terraform-asg-example"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default.ids
  # raccrocher ALB au groupe de sécurité
  security_groups = [aws_security_group.firewall.id]
}

# Définit un écouteur  pour l'ALB

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port = 80
  protocol = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }
}

# définit security_group pour entrées/sorties

resource "aws_security_group" "firewall" {
  name = "terraform-example-firewall"

  # allow inbound HTTP requests
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow all outbound requests
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Créer un groupe cibble pour l'ASG

resource "aws_lb_target_group" "asg" {
  name = "terraform-asg-example"
  port = var.server_port
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_autoscaling_group" "example" {
  launch_configuration = aws_launch_configuration.example.name
  vpc_zone_identifier = data.aws_subnet_ids.default.ids
  
  # définit son argument target_group_arns pour pointer vers le nouveau groupe ciblé
  target_group_arns = [aws_lb_target_group.asg.arn]
  health_check_type = "ELB"

  min_size = 2
  max_size = 5

  tag {
    key = "Name"
    value = "terraform-asg-exemple"
    propagate_at_launch = true
  }
}

# ajoute une règle d'écouteur (listening) qui envoie des requêtes
# correspondant à n'importe quel chemin d'accès au groupe cible qui contient l'ASG

resource "aws_lb_listener_rule" "asg" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.asg.arn
  }
}







