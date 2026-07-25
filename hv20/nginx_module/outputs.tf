output "public_ip" {
  value       = aws_instance.nginx_server.public_ip
  description = "Публічна IP-адреса створеного EC2-екземпляра"
}

output "nginx_url" {
  value       = "http://${aws_instance.nginx_server.public_ip}"
  description = "Посилання для перевірки роботи Nginx"
}
