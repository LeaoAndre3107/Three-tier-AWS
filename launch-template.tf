resource "aws_launch_template" "app" {
  name_prefix = "app-tier"
  image_id = aws_ami_from_instance.app_ami.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [
    aws_security_group.app_ec2.id
  ]

  iam_instance_profile {
    name =  aws_iam_instance_profile.ec2_profile.name
    }
  tag_specifications {
    resource_type = "instance"

    tags = {
        Name = "app-tier"
    }
  }
}