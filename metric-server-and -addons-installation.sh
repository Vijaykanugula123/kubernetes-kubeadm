to get the token lifetime
kubeadm token create --ttl 0 --print-join-command

output 
#kubeadm join ip:6443 --token f8nxj2.qwdqhbkpl1chanlfly5qmcht5p6 --discovery-token-ca-cert-hash sha256:qwdjjb


 run the above on the worker nodes to join


if calico pods not running for particular nodes

cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF
systemctl daemon-reexec
systemctl restart kubelet


ls /etc/resolv.conf
vi /etc/default/kubelet
KUBELET_EXTRA_ARGS=--node-ip=<ip-addr> --resolv-conf=/etc/resolv.conf



systemctl daemon-reexec
systemctl restart kubelet
systemctl restart containerd

kubectl delete pods which are on container creating state in calico-system name space







# if you want to change the host names

✅ Step-by-step fix
🔥 Step 1: Drain node (on MASTER)
kubectl drain tradelab --ignore-daemonsets --delete-emptydir-data
🔥 Step 2: Delete node from cluster
kubectl delete node tradelab
🔥 Step 3: Go to WORKER node
Change hostname:
hostnamectl set-hostname kube-wn1
Update /etc/hosts (IMPORTANT)
vi /etc/hosts

Replace:

127.0.1.1   admin

With:

127.0.1.1   kube-wn1
🔥 Step 4: Reset kubeadm (on worker)
kubeadm reset -f
🔥 Step 5: Restart services
systemctl restart containerd
systemctl restart kubelet
🔥 Step 6: Rejoin cluster

Use your same join command:

kubeadm join <ip-addr>:6443 \
--token f8nxj2wdqqp9.weef \
--discovery-token-ca-cert-hash sha256:q3fho
✅ Step 7: Verify (on MASTER)
kubectl get nodes




✅ Solution: Install Metrics Server
🚀 Step 1: Apply Metrics Server

Run on master node:

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
⏳ Step 2: Wait for pod
kubectl get pods -n kube-system | grep metrics

👉 Wait until:

metrics-server-xxxxx   Running
❗ Step 3: FIX (VERY IMPORTANT for your setup)

Since you are using:

self-signed certs (kubeadm)
internal IPs

👉 Metrics server will FAIL unless patched

🔥 Patch metrics-server
kubectl edit deployment metrics-server -n kube-system
Find this section:
containers:
- args:
Add these lines:
- --kubelet-insecure-tls
- --kubelet-preferred-address-types=InternalIP
✅ Final args should look like:
args:
- --cert-dir=/tmp
- --secure-port=10250
- --kubelet-insecure-tls
- --kubelet-preferred-address-types=InternalIP
🔁 Step 4: Restart pod
kubectl delete pod -n kube-system -l k8s-app=metrics-server
⏳ Step 5: Wait again
kubectl get pods -n kube-system -w
✅ Step 6: Test
kubectl top nodes
🎯 Expected output
NAME           CPU(cores)   MEMORY(bytes)
kube-master    100m         500Mi
kube-wn1       200m         800Mi
