pathpet=/home/pet
mkdir $pathpet
cd $pathpet
git clone https://github.com/spring-projects/spring-petclinic
apt update
apt install -y  openjdk-21-jdk  maven
cd $pathpet/spring-petclinic
mvn package

cat <<EOF > /etc/systemd/system/petclinic.service

[Unit]
Description=Spring PetClinic Application
After=network.target postgresql.service

[Service]
User=root
Group=root
WorkingDirectory=/home/pet/
Environment="POSTGRES_URL=jdbc:postgresql://192.168.31.51:5432/app_db"
Environment="POSTGRES_USER=app"
Environment="POSTGRES_PASS=secure_password_123"
ExecStart=/usr/bin/java -jar spring-petclinic/target/spring-petclinic-4.0.0-SNAPSHOT.jar --spring.profiles.active=postgres
SuccessExitStatus=143
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target

EOF

systemctl daemon-reload
systemctl enable --now petclinic
systemctl status petclinic
