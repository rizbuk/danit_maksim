# Підключення до Private Worker через Master
ssh -J ubuntu@<18.159.45.228> ubuntu@<10.0.2.16>

# Встановлення Java на Worker
sudo apt update && sudo apt install -y openjdk-21-jre

# Запуск агента за допомогою згенерованої в UI команди
mkdir -p /home/ubuntu/jenkins && cd /home/ubuntu/jenkins
curl -sO http://10.0.1.127:8080/jnlpJars/agent.jar
java -jar agent.jar -url http://10.0.1.127:8080/ -secret 7b4e3d99114bd40d37e178f5fca980a635ee61886f0f1f650a7d2ac4bee63260 -name worker -webSocket -workDir "/home"
