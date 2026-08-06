provider "aws" {
  region = "eu-central-1"
}

resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-0ec7f9846da6b0f61" # Ubuntu 24.04 LTS у eu-central-1
  instance_type = "t3.micro"
  key_name = "my-key"
  subnet_id =   "subnet-006adeebbcd19faac"
  vpc_security_group_ids      = ["sg-0482d6ec2677b8a52"]

  tags = {
    Name = "web-server-${count.index}"
  }
}

resource "local_file" "ansible_inventory" {
  filename = "./inventory.ini"
  content  = <<EOT
[web_servers]
${join("\n", aws_instance.web.*.public_ip)}

[web_servers:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/id_rsa
EOT
}