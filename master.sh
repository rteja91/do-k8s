#!/bin/bash
# Replace this with the token 
TOKEN=oc6q8t.62x8d8a4mkeeww0n

apt-get update && apt-get upgrade -y 

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

cat <<EOF > /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update -y

apt-get install -y docker.io
apt-get install -y --allow-unauthenticated kubelet kubeadm kubectl kubernetes-cni

export MASTER_IP=$(curl -s https://api.ipify.org)
kubeadm init --pod-network-cidr=10.244.0.0/16  --apiserver-advertise-address $MASTER_IP --token $TOKEN

cp /etc/kubernetes/admin.conf $HOME/
chown $(id -u):$(id -g) $HOME/admin.conf
export KUBECONFIG=$HOME/admin.conf

kubectl create -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/k8s-manifests/kube-flannel-rbac.yml --namespace=kube-system
kubectl create -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml --namespace=kube-system
kubectl create -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml --namespace=kube-system

