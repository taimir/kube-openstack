#!/bin/bash

# Install prerequisites
# 	* docker
#	* socat
#	* kubelet (systemd service)
#	* kubectl (/usr/bin binary)
# * kubeadm (/usr/bin binary)
echo "Starting provisioning with kubeadm"
sudo apt-get update
sudo apt-get install -y docker.io socat apt-transport-https

# hack for openstack
sudo systemctl unmask docker.socket
sudo systemctl restart docker

curl -s -L https://storage.googleapis.com/kubeadm/kubernetes-xenial-preview-bundle.txz | tar xJv
sudo dpkg -i kubernetes-xenial-preview-bundle/*.deb

# hack for openstack
sudo sed -i -e 's#KUBELET_EXTRA_ARGS=#KUBELET_EXTRA_ARGS=--cloud-config=/etc/kubernetes/cloud-config.json --cloud-provider=openstack #g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf

cat <<EOF > /etc/kubernetes/cloud-config.json
[global]
auth-url=http://172.31.0.101:5000/v2.0
username=mirchev
password=secret
tenant-id=91908fb11f60410eb2574d9fcea3fd52
tenant-name=k8s-autoscale
# domain-id=default
# domain-name=Default
EOF

sudo systemctl daemon-reload
sudo systemctl restart kubelet
