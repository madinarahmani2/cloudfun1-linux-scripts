# What This Script Does
## This Bash script automates the installation and setup of a Node.js application with MongoDB, Nginx as a reverse proxy, and PM2 as a process manager. Here's a step-by-step breakdown of what happens:


#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update -y

# Upgrade system packages
echo "Upgrading system packages..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

# Install Nginx
echo "Installing Nginx..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install nginx -y

# Download Node.js setup script
echo "Downloading Node.js setup script..."
curl -fsSL https://deb.nodesource.com/setup_20.x -o setup_nodejs.sh

# Run the Node.js setup script
echo "Setting up Node.js..."
sudo DEBIAN_FRONTEND=noninteractive bash setup_nodejs.sh

# Install Node.js
echo "Installing Node.js..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install nodejs -y

# Configure Nginx as a reverse proxy
echo "Configuring Nginx as a reverse proxy..."
sudo sed -i 's|try_files.*;|proxy_pass http://localhost:3000/;|' /etc/nginx/sites-available/default
sudo systemctl reload nginx
sudo systemctl restart nginx

# Clone the application repository
echo "Cloning the application repository..."
git clone https://github.com/daraymonsta/tech201-sparta-app /repo

# Navigate to the application directory
echo "Navigating to the application directory..."
cd /repo/app || { echo "Application directory not found. Exiting."; exit 1; }

# Export the MongoDB connection string
echo "Setting up MongoDB connection string..."
export DB_HOST=mongodb://10.0.3.4:27017/posts

# Install PM2 process manager
echo "Installing PM2..."
sudo npm install -g pm2

# Install application dependencies
echo "Installing application dependencies..."
npm install

# Populate the database
echo "Populating the database..."
node seeds/seed.js

# Stop any running PM2 apps
echo "Stopping any running PM2 apps..."
pm2 kill

# Start the application with PM2
echo "Starting the application..."
pm2 start app.js

# Check versions of Node.js and npm
echo "Checking installed versions..."
node -v
npm -v

# Final message
echo "Application setup completed successfully."
