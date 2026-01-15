resource "aws_ami_from_instance" "app_ami" {
  name = "three-tier-app-ami"
  source_instance_id = aws_instance.app.id

  tags = {
    Name = "three-tier-app-ami"
  }
}

