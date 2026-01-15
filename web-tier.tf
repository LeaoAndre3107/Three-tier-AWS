locals {
  web_user_data = <<-EOF
  #!/bin/bash
  yum update -y 

  amazon-linux-extras install nginx1 -y
  systemctl start nginx
  systemctl enable nginx

  curl -sL https://rpm.nodesource.com/setup_18.x | bash
  yum install -y nodejs

  mkdir -p /usr/share/nginx/html
  cat << 'HTML'> usr/share/nginx/html/index.html
  <!DOCTYPE htm>
  <html>
  <head>
    <title>Three Tier web App</title>
  </head>

  <body>
    <h1> Web Tier funcionando 🚀</h1>
    <p> requisições para /api são encaminhadas para o App Tier.</p>
  </body>
  </html>
  HTML

  cat <<'NGINX'> /etc/nginx/conf.d/app.conf
  server {
    listen 80;
    location / {
            root /usr/share/nginx/html;
            index index.html;}
    location /api/ {
            proxy_pass http:${aws_lb.app.dns_name}:4000/;
        }
    }

    NGINX

    systemctl restar nginx

    EOF
}

resource "aws_instance" "web" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_a.id

  vpc_security_group_ids = [aws_security_group.web_ec2.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  
  user_data = local.web_user_data

  tags ={ 
    Name = "web-tier-instance"
  }
}