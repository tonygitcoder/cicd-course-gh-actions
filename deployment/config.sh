# Docker
sudo apt update
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y

# Relogin to the host via ssh after this command
sudo usermod -aG docker $USER && newgrp docker

# kubectl
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/v1.8.0/bin/linux/amd64/kubectl && chmod +x kubectl && sudo mv kubectl /usr/local/bin/
source <(kubectl completion bash)

# Minikube
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
source <(minikube completion bash)

# Start
minikube start

# Deploy chart the first time
helm install aws-cicd-pipeline ./deployment/aws-cicd-pipeline --set image.tag=v1.0.1

# IMPORTANT:
# To make the pipeline work, you need to create a secret in github with the EC2 instance public IP and the SSH key
# The secrets should be called "EC2_PUBLIC_IP" and "AWS_EC2_SSH_KEY" respectively
# The SSH key should be base64 encoded
