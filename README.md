# 🏗️ AWS Three-Tier Web Architecture com Terraform

Este repositório contém a implementação completa de uma **Arquitetura Web Three-Tier na AWS**, provisionada **100% via Terraform**, seguindo as **boas práticas oficiais da AWS** e baseada no workshop *AWS Three Tier Web Architecture*.

A infraestrutura foi construída com foco em **alta disponibilidade, escalabilidade, segurança e automação**, utilizando **Infrastructure as Code (IaC)**.

---

## 📌 Visão Geral da Arquitetura

A aplicação é dividida em três camadas independentes:

Internet
↓
External Application Load Balancer (Web Tier)
↓
Auto Scaling Group (Web EC2 + NGINX)
↓
Internal Application Load Balancer (App Tier)
↓
Auto Scaling Group (App EC2 + Node.js)
↓
Amazon Aurora (Data Tier)
---

## 🎯 Objetivos do Projeto

- Implementar uma arquitetura Three-Tier altamente disponível
- Automatizar toda a infraestrutura com Terraform
- Aplicar segurança em camadas (Defense in Depth)
- Utilizar Auto Scaling e Load Balancers
- Eliminar dependência de acesso SSH (uso de AWS SSM)
- Seguir padrões reais de produção

---

## 🧱 Componentes Provisionados

### 🔹 Networking
- VPC dedicada
- Subnets públicas e privadas em múltiplas AZs
- Internet Gateway
- NAT Gateway
- Tabelas de rota

### 🔹 Segurança
- Security Groups com regras restritivas por camada
- IAM Role para EC2
- Acesso administrativo via AWS Systems Manager (SSM)

### 🔹 Web Tier
- EC2 com NGINX
- Reverse proxy para App Tier
- AMI customizada
- Auto Scaling Group
- Application Load Balancer público

### 🔹 App Tier
- EC2 com Node.js (porta 4000)
- AMI customizada
- Auto Scaling Group
- Application Load Balancer interno

### 🔹 Data Tier
- Amazon Aurora
- Subnets privadas
- Acesso restrito apenas ao App Tier

---

## 📂 Estrutura do Repositório
├── provider.tf
├── variables.tf
├── outputs.tf
├── vpc.tf
├── subnets.tf
├── routes.tf
├── security-groups.tf
├── iam.tf
├── s3.tf
├── app-tier.tf
├── app-ami.tf
├── alb-app.tf
├── asg-app.tf
├── web-tier.tf
├── web-ami.tf
├── alb-web.tf
├── asg-web.tf
└── README.md


---

## ⚙️ Pré-requisitos

- AWS Account
- AWS CLI configurado (`aws configure`)
- Terraform >= 1.5
- Permissões para criar:
  - VPC
  - EC2
  - ALB
  - Auto Scaling
  - IAM
  - RDS (Aurora)
  - S3

---


# Three-tier-AWS
