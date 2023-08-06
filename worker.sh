#! /bin/bash
apt-get update -y
apt-get upgrade -y
hostname worker && bash
curl -sfL https://get.k3s.io | K3S_URL=${url} K3S_TOKEN=${sifre} sh -