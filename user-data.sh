## This is for the user data when you have a fresh new vm for app


#!/bin/bash

# Update and upgrade system packages
sudo apt update -y
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

# Install Nginx
sudo DEBIAN_FRONTEND=noninteractive apt-get install nginx -y

# Install Node.js from NodeSource
curl -fsSL https://deb.nodesource.com/setup_20.x -o setup_nodejs.sh
sudo DEBIAN_FRONTEND=noninteractive bash setup_nodejs.sh
sudo DEBIAN_FRONTEND=noninteractive apt-get install nodejs -y

# Modify Nginx configuration to set up reverse proxy
sudo sed -i 's|try_files.*;|proxy_pass http://localhost:3000/;|' /etc/nginx/sites-available/default
sudo nginx -t && sudo systemctl restart nginx

# Clone the application repository
git clone https://github.com/daraymonsta/tech201-sparta-app /repo

# Navigate to the app directory
cd /repo/app

# Set up the database connection environment variable
echo "export DB_HOST=mongodb://10.0.3.4:27017/posts" >> ~/.bashrc
export DB_HOST=mongodb://10.0.3.4:27017/posts

# Install PM2 globally and app dependencies
sudo npm install -g pm2
npm install

# Start the application with PM2
pm2 start app.js