provider "aws" {
  region = "eu-central-1"
}

module "my_nginx" {
  source             = "./nginx_module"
  vpc_id             = "vpc-0fe15866e4635a2a7"    # Замініть на ваш VPC ID
  public_subnet_id   = "subnet-0d01bef2ad7bf249b" # Замініть на вашу публічну підмережу
  list_of_open_ports = [80, 22]                   # Відкриваємо 80 для веб та 22 для SSH за потреби
}

output "nginx_check_url" {
  value = module.my_nginx.nginx_url
}
