variable "vpc_id" {
  type        = string
  description = "Ідентифікатор VPC, де будуть створені ресурси"
}

variable "list_of_open_ports" {
  type        = list(number)
  description = "Список портів, які потрібно відкрити в Security Group (наприклад, [80, 443])"
}

variable "public_subnet_id" {
  type        = string
  description = "Ідентифікатор публічної підмережі для EC2-екземпляра"
}
