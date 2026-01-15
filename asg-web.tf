resource "aws_autoscaling_group" "web" {
  name = "web-tier-asg"

  min_size = 2
  max_size = 4
  desired_capacity = 2

  vpc_zone_identifier = [ 
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
   ]

   launch_template {
     id = aws_launch_template.web.id
     version = "$Latest"
   }

   target_group_arns = [ aws_lb_target_group.web.arn ]

   health_check_type = "ELB"
   health_check_grace_period = 300

   tag {
     key = "Name"
     value = "web-tier"
     propagate_at_launch = true
   }
}