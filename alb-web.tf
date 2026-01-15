resource "aws_security_group" "alb_web" {
  name = "alb-web-public-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0./0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "web" {
  name = "web-tier-tg"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id

  health_check {
    path = "/"
  }
}

resource "aws_lb" "web" {
  name = "web-public-alb"
  load_balancer_type = "application"
  internal = false

  security_groups = [ aws_security_group.alb_web.id ]
  subnets = [ 
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
   ]
}

resource "aws_lb_listener" "web" {
  load_balancer_arn = aws_lb.web.arn
  port = 80
  protocol = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}