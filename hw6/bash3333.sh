sudo /usr/sbin/sshd -d -p 3333 -o "PermitRootLogin no" -o "PasswordAuthentication yes" -o "PubkeyAuthentication yes"
