data "aws_ami" "amazon_linux" {
    most_recent = true
    owners = ["amazon"]

    filter {
      name = "name"
      values = ["amzn2-ami-hvm-*-x86_64-gp2"]
    }
}

resource "aws_rds_cluster" "aurora" {
  cluster_identifier = "three-tier-aurora"
  engine             = "aurora-mysql"
  db_subnet_group_name = aws_db_subnet_group.aurora.name
  master_username = "admin"
  master_password = "password123"

  skip_final_snapshot = true
}


locals {
    app_user_data = <<-EOF
        #!/bin/bash
        yum update  -y

        /* Instalando o node.js */       
        curl -sl https://rpm.nodesource.com/setup_18.x | bahs - 
        yum install -y nodejs mysql

        /* Criando um diretorio */
        mkdir -p /opt/app
        cd /opt/app

        /* Criando o app node.js simples */
        cat <<'APP' > app.js
        const http = require('http');
        const mysql = require('msql');

        const db = mysql.createConnection({
            host: "${aws_rds_cluster.aurora.endpoint}",
            user: "admin",
            password: "password123",
            database:"workshop"
            });
        
        db.connect(err=>{
            if (err) {
            console.erro("DB connections failed:", err);
            process.exit(1);}
            console.log("Connected to DB");
        });

        const server = http.createServer ((req, res) => {
        res.writeHead(200);
        res.end("App Tier Funcionando!");
        });

        server.isten(4000);
        APP

        /* Inicializando o BAnco */
        mtsql -h ${aws_rds_cluster.aurora.endpoint} -u admin -ppassword123 <<SQL
        CREAT DATABASE IF NOT EXISTS workshop;
        USE workshop;
        CREATE TABLE IF NOR EXISTS messages(id INT AUTO_INCREMENT PRIMARY KEY,
        content VARCHAR(255)
        );
        
        SQL

        /* Rodar o App */
        node /opt/app/app.js &
    EOF
}

resource "aws_instance" "app" {
  ami = data.aws_ami.amazon_linux.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.app_a.id
  vpc_security_group_ids = [aws_security_group.app_ec2.id]

  iam_instance_profile = aws_iam_instance_profile.ec2_profile.name
  user_data = local.app_user_data

  tags = {
    Name = "app-tier-instance"
  }
}
    