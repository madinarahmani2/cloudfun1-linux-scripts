#!/bin/bash


# sparta app vm 

## ubuntu 22.04
## standard 
## vm network under my name
## public subnet 
## advanced
## create new 
## add an inbound rule 80 and 3000
## add tags and review
## create 



### COMMANDS:

# update
sudo apt update -y
 
# upgrade (completely noninteractive)
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y
 
# install nginx
sudo DEBIAN_FRONTEND=noninteractive apt-get install nginx -y

# download nodejs shell script
curl -fsSL https://deb.nodesource.com/setup_20.x -o setup_nodejs.sh
 
# run setup_nodejs.sh (bash is used to run the file) (this readies all the files)
sudo DEBIAN_FRONTEND=noninteractive bash setup_nodejs.sh
 
# sudo apt-get install nodejs (use "node -v" to get version)
sudo DEBIAN_FRONTEND=noninteractive apt-get install nodejs -y

# reverse proxy 
sudo sed -i 's|try_files.*;|proxy_pass http://localhost:3000/;|’ /etc/nginx/sites-available/default

# restart nginx
sudo systemctl reload nginx
sudo systemctl restart nginx

# git clone 
git clone https://github.com/daraymonsta/tech201-sparta-app /repo
 
# change into app directory 
cd repo 
cd app 

# export the mongod 
export DB_HOST=mongodb://10.0.3.4:27017/posts

# Install pm2 process manager
sudo npm install -g pm2

# cd into app folder
cd /sparta-app/app

# install app
npm install

# populate database
node seeds/seed.js

# stop all apps
pm2 kill

# start app
pm2 start app.js

# check the versions 
node.js -v
npm - v

#  IF ERROR SHOWS 
## jobs -l 
# check if one is running use 
## kill 
## npm start 
## ps aux
# should work now 

#run app app from home directory 
node app.js & 