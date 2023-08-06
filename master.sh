#! /bin/bash
apt-get update -y
apt-get upgrade -y
hostname master && bash 
curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --token ${sifre}