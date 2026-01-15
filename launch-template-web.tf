resource "aws_launch_template" "web" {
  name_prefix = "web-tier-"
  image_id = aws_ami_from_instance.web_ami.id
  instance_type = "t3.micro"

  vpc_security_group_ids = [ aws_security_group.web_ec2.id ]
  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_profile.name
  }
  tag_specifications {
    resource_type = "instance"

    tags = {Name = "web-tier"}
  }
}

