#!/bin/bash

# Install prerequisites
# 	* docker
#	* socat
#	* kubelet (systemd service)
#	* kubectl (/usr/bin binary)
# 	* kubeadm (/usr/bin binary)
echo "Starting provisioning with kubeadm"
sudo apt-get update
sudo apt-get install -y docker.io socat apt-transport-https
curl -s -L https://storage.googleapis.com/kubeadm/kubernetes-xenial-preview-bundle.txz | tar xJv
sudo dpkg -i kubernetes-xenial-preview-bundle/*.deb
