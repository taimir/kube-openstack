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
sudo sed -i -e 's#KUBELET_EXTRA_ARGS=#KUBELET_EXTRA_ARGS=--cloud-config=/home/ubuntu/heat-config.ini --cloud-provider=openstack #g' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
sudo systemctl daemon-reload
sudo systemctl restart kubelet
