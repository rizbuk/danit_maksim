sudo mkdir -p /home/john/.ssh
sudo touch /home/john/.ssh/authorized_keys
# Paste your public key into /home/john/.ssh/authorized_keys
sudo chown -R john:john /home/john/.ssh
sudo chmod 700 /home/john/.ssh
sudo chmod 600 /home/john/.ssh/authorized_keys
