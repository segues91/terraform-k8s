#Master config
ssh centos@PUBLIC_IP -i centos
sudo yum install wget -y
sudo -i
yum update
yum upgrade
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
usermod -aG docker centos
systemctl start docker
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
yum install -y kubelet-1.14.1 kubeadm-1.14.1 kubectl-1.14.1 --disableexcludes=kubernetes
systemctl enable --now kubelet
kubeadm init \
     --kubernetes-version 1.14.1 \
     --pod-network-cidr 192.168.0.0/16 \
    | tee kubeadm-init.out
exit
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
wget https://tinyurl.com/yb4xturm -O rbac-kdd.yaml
wget https://tinyurl.com/y8lvqc9g -O calico.yaml
kubectl apply -f rbac-kdd.yaml
kubectl apply -f calico.yaml
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc
#Worker config
sudo -i
yum update
yum upgrade
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce
systemctl start docker
cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kube*
EOF
setenforce 0
sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config
yum install -y kubelet-1.14.1 kubeadm-1.14.1 kubectl-1.14.1 --disableexcludes=kubernetes
systemctl enable kubelet.service
kubeadm join 10.132.0.3:6443 --token rx281c.cfeuge8elra01shk \
    --discovery-token-ca-cert-hash sha256:e9ac02ad16d0a750200ac42c0825dfdf3158b5bf5eb15323eab3518f671ac350
#Postconfiguration
#On master node
kubectl taint nodes \
         --all node-role.kubernetes.io/master-
kubectl taint nodes \
         --all node.kubernetes.io/not-ready-
# Check the cluster
kubectl get nodes
# Docker registry private on master node
docker run -d -p 5000:5000 --restart=always --name registry registry:2
# On each node
sudo vim /etc/docker/daemon.json
# copy paste
{
    "insecure-registries" : [ "hostname.cloudapp.net:5000" ]
}
sudo systemctl daemon-reload
sudo systemctl restart docker