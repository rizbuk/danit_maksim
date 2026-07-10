docker build -t 984140674362.dkr.ecr.eu-central-1.amazonaws.com/test:latest .
#aws login
#aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin 984140674362.dkr.ecr.eu-central-1.amazonaws.com
                                                                                                 984140674362.dkr.ecr.eu-central-1.amazonaws.com/test
docker push 984140674362.dkr.ecr.eu-central-1.amazonaws.com/test:latest