#!/bin/bash

apt update
apt upgrade
apt install nginx -y
apt install npm -y
apt install git -y
apt install node -y
apt install nodejs -y
apt install mysql-client -y
git clone https://github.com/carlosandrescardenas/movie-analyst-api.git
cd /movie-analyst-api/data_model
mysql -h ${endpoint} -u admin -prampuptest2021  < db_creation.sql
mysql -h ${endpoint} -u admin -prampuptest2021 movie_db < table_creation_and_inserts.sql
cd ..
npm install
echo export DB_HOST=${endpoint} | sudo tee -a /etc/environment
echo export DB_USER=admin | sudo tee -a /etc/environment
echo export DB_PASS=rampuptest2021 | sudo tee -a /etc/environment
echo export DB_NAME=movie_db | sudo tee -a /etc/environment
cd /movie-analyst-api/
node server.js