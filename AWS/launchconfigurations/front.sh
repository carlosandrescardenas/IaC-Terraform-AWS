#!/bin/bash

apt update
apt upgrade
apt install nginx -y
apt install npm -y
apt install git -y
apt install node -y
apt install nodejs -y
git clone https://github.com/carlosandrescardenas/movie-analyst-ui.git
cd /movie-analyst-ui/
npm install
node server.js