resource "aws_autoscaling_group" "app" {
  name = "app-tier-asg"

  desired_capacity = 2
  max_size = 4
  min_size = 2

  vpc_zone_identifier = [
    aws_subnet.app_a.id,
    aws_subnet.app_b.id
  ]
  
  launch_template {
    id = aws_launch_template.app.id
    version= "$Latest"
  }

target_group_arns = [
    aws_lb_target_group.app.arn
]

health_check_type = "ELB"
health_check_grace_period = 300

tag {
  key = "Name"
  value = "app-tier"
  propagate_at_launch = true 
  }
}