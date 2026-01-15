resource "aws_security_group" "alb_app" {
  name = "alb-app-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 4000
    to_port = 4000
    protocol = "tcp"
    security_groups = [aws_security_group.web_ec2.id]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb_target_group" "app" {
  name = "app-tier-tg"
  port = 4000
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id

  health_check {
    path = "/"
    port = "4000"
  }
}

resource "aws_lb" "app" {
  name = "app-internal-alb"
  internal = true
  load_balancer_type = "application"
  security_groups = [aws_security_group.alb_app.id]

  subnets = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id
  ]
}

resource "aws_lb_listener" "app"{
    load_balancer_arn = aws_lb.app.arn
    port = 4000
    protocol = "HTTP"

    default_action {
      type = "forward"
      target_group_arn = aws_lb_target_group.app.arn
    }
}