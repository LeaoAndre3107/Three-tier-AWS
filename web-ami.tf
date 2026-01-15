resource "aws_ami_from_instance" "web_ami" {
  name = "three-tier-web-ami"
  source_instance_id = aws_instance.web.id

  tags = {
    Name = "three-tier-web-ami"
  }
}