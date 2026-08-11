output "jenkins_master_public_ip" {
  value       = aws_instance.jenkins_master.public_ip
  description = "Публічна IP-адреса Jenkins Master для доступу через браузер"
}

output "jenkins_worker_private_ip" {
  value       = aws_spot_instance_request.jenkins_worker.private_ip
  description = "Приватна IP-адреса Jenkins Worker для підключення до Master"
}
