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
mysql -h moviedb.cx02uzagq3fl.us-west-1.rds.amazonaws.com -u admin -prampuptest2021  < db_creation.sql
mysql -h moviedb.cx02uzagq3fl.us-west-1.rds.amazonaws.com -u admin -prampuptest2021 movie_db < table_creation_and_inserts.sql
cd ..
npm install
node server.js