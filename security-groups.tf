resource "aws_security_group" "alb_web" {
  name   = "alb-web-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress  {
    from_port  = 0
    to_port    = 0
    protocol   = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "web_ec2" {
  name   = "web-ec2-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_web.id]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["192.141.123.68/32"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "app_ec2" {
  name   = "app-ec2-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.web_ec2.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name   = "db-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_ec2.id]
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "three-tier-ec2-sg"
  description = "Security Group para EC2 - SSH somente do meu IP" #i'm utilizing that this connections for access ssh only myIP number
  vpc_id      = aws_vpc.main.id

  ingress  {
    description = "SSH somente do meu IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.141.123.68/32"]
  }

  egress  {
    description = "Saida Liberada"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "three-tier-ec2-sg"
  }
}

resource "aws_db_subnet_group" "aurora" {
  name       = "three-tier-db-subnet-group"
  subnet_ids = [
    aws_subnet.db_a.id,
    aws_subnet.db_b.id
  ]

  tags = {
    Name = "three-tier-db-subnet-group"
  }
}
