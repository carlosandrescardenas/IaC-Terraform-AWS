#!/bin/bash

apt update
apt upgrade
add-apt-repository ppa:ansible/ansible
apt update
apt install ansible -y
git clone https://github.com/carlosandrescardenas/ansible-configuration.git
cd /ansible-configuration/
