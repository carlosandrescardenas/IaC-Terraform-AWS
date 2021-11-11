#!/bin/bash

apt update
apt upgrade
apt install software-properties-common
add-apt-repository --yes --update ppa:ansible/ansible
apt install ansible -y
git clone https://github.com/carlosandrescardenas/ansible-configuration.git
cd /ansible-configuration/playbooks
