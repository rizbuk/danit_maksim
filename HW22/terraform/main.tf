provider "aws" {
  region = var.aws_region
}

# --- МЕРЕЖЕВА ІНФРАСТРУКТУРА (VPC) ---

resource "aws_vpc" "jenkins_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags                 = { Name = "jenkins-vpc" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.jenkins_vpc.id
  tags   = { Name = "jenkins-igw" }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.jenkins_vpc.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone       = "${var.aws_region}a"
  tags                    = { Name = "jenkins-public-subnet" }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.jenkins_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "${var.aws_region}a"
  tags              = { Name = "jenkins-private-subnet" }
}

# NAT Gateway для приватної підмережі
resource "aws_eip" "nat_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw]
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags          = { Name = "jenkins-nat-gw" }
}

# Таблиці маршрутизації
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.jenkins_vpc.id
  route {
    cidr_block = "0.0.0.0/8" # Тимчасовий заповнювач для коректного парсингу AWS
    gateway_id = aws_internet_gateway.igw.id
  }
  # Справжній маршрут за замовчуванням
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "jenkins-public-rt" }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.jenkins_vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = { Name = "jenkins-private-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# --- БЕЗПЕКА (Security Groups) ---

resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-security-group"
  description = "Allow SSH and HTTP/HTTPS traffic"
  vpc_id      = aws_vpc.jenkins_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Задля безпеки в продакшені змініть на свій IP
  }

  ingress {
    description = "HTTP access (Nginx Proxy)"
    from_port   = 80
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins master-worker communication"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "jenkins-sg" }
}

# --- СЕРВЕРИ (EC2) ---

# Отримання актуального AMI для Ubuntu 24.04 LTS
data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

# Створення Key Pair в AWS через Terraform за допомогою вашого публічного ключа
resource "aws_key_pair" "deployer_key" {
  key_name   = "jenkins-deployer-key"
  public_key = var.my_public_ssh_key
}

# Script User-Data для інжекту ключа на випадок, якщо потрібен прямий пропис через метадані
locals {
  user_data_ssh = <<-EOF
                  #!/bin/bash
                  echo "${var.my_public_ssh_key}" >> /home/ubuntu/.ssh/authorized_keys
                  chmod 600 /home/ubuntu/.ssh/authorized_keys
                  chown ubuntu:ubuntu /home/ubuntu/.ssh/authorized_keys
                  EOF
}

# On-Demand екземпляр для Jenkins Master
resource "aws_instance" "jenkins_master" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type_master
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = aws_key_pair.deployer_key.key_name
  user_data              = local.user_data_ssh

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = { Name = "jenkins-master" }
}

# Spot екземпляр для Jenkins Worker
resource "aws_spot_instance_request" "jenkins_worker" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = var.instance_type_worker
  spot_price             = "0.03" # Максимальна ціна за годину
  spot_type              = "one-time"
  wait_for_fulfillment   = true
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.jenkins_sg.id]
  key_name               = aws_key_pair.deployer_key.key_name
  user_data              = local.user_data_ssh

  root_block_device {
    volume_size = 30
    volume_type = "gp3"
  }

  tags = { Name = "jenkins-worker" }
}
