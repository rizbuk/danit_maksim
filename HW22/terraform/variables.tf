variable "aws_region" {
  type        = string
  default     = "eu-central-1"
  description = "Регіон AWS для розгортання інфраструктури"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR блок для VPC"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.0.1.0/24"
  description = "CIDR блок для публічної підмережі (Master)"
}

variable "private_subnet_cidr" {
  type        = string
  default     = "10.0.2.0/24"
  description = "CIDR блок для приватної підмережі (Worker)"
}

variable "my_public_ssh_key" {
  type        = string
  description = "Ваш публічний SSH ключ (наприклад, 'ssh-ed25519 AAAAC3...')"
}

variable "instance_type_master" {
  type        = string
  default     = "t3.micro"
  description = "Тип екземпляра для Jenkins Master"
}

variable "instance_type_worker" {
  type        = string
  default     = "t3.micro"
  description = "Тип екземпляра для Jenkins Worker"
}