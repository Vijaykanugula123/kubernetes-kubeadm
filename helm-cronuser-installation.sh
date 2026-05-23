creating cron user on jump server 

sudo useradd -m -s /bin/bash cron
sudo passwd -l cron



🚀 Install kubectl (Debian / Ubuntu)

Run these commands on your server:

✅ Step 1: Update packages
sudo apt-get update
✅ Step 2: Install required tools
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
✅ Step 3: Add Kubernetes repository
sudo mkdir -p /etc/apt/keyrings

curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.34/deb/Release.key \
| sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
✅ Step 4: Add repo to sources
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.34/deb/ /" \
| sudo tee /etc/apt/sources.list.d/kubernetes.list
✅ Step 5: Install kubectl
sudo apt-get update
sudo apt-get install -y kubectl
✅ Step 6: Verify installation
kubectl version --client


##  copy the kube config to the jump server cron user

Step 1: Copy to tradelab home first
scp /etc/kubernetes/admin.conf admin@ip-addr:/tmp/admin.conf
Step 2: Login to target server
ssh admin@ip-addr
Step 3: Move file to cron user (with sudo)
sudo mkdir -p /home/cron/.kube
sudo mv /tmp/admin.conf /home/cron/.kube/config
Step 4: Fix permissions
sudo chown -R cron:cron /home/cron/.kube
sudo chmod 600 /home/cron/.kube/config

chown -R cron:cron /apps

kubectl get nodes 
kubectl get pods


🚀 Install Helm (Debian / Ubuntu)
✅ Step 1: Download Helm
curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

👉 This is the official installation script (fastest way)

✅ Step 2: Verify installation
helm version
