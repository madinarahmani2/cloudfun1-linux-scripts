# What This Script Does 
## This Bash script automates the installation, configuration, and setup of MongoDB (version 7.0.6) on an Ubuntu-based virtual machine. Below is a step-by-step explanation of each section and what you can expect when the script runs.

#!/bin/bash

# update vm packages
sudo apt update -y

# upgrade packages
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

## Update and Upgrade Packages
## Ensures the system is up-to-date by updating the package index and upgrading installed packages.


# install gnup and curl if not already installed 
sudo DEBIAN_FRONTEND=noninteractive apt-get install gnupg curl

### Install Dependencies
### Installs gnupg and curl if they are not already present. These tools are required to fetch and verify the MongoDB public GPG key.


# import mongodb public GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

### Import MongoDB Public GPG Key
### Imports the official MongoDB GPG key for package verification and saves it in a secure location.


# create mongoDB list file
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

## Set Up MongoDB Repository
## Adds the MongoDB repository to the system’s sources list for package installation.


# update the mongoDB package
sudo apt-get update

# download specific version of mongoDB
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

## Install MongoDB Version 7.0.6
## Updates the package list and installs the specified version of MongoDB along with its components.


# prevent mongdb package from upgrading
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

## Prevent Package Upgrades
## Prevents MongoDB packages from being upgraded automatically to newer versions.


# start MongoDB
sudo systemctl start mongod

## Start MongoDB
## Starts the MongoDB service.

# change config of mongod local ip to default gateway
sudo sed -i.bak 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf 

## Configure MongoDB to Listen on All IPs
## Updates MongoDB’s bindIp configuration to allow connections from any IP address.


####   IF ERROR SHOWS 
# checking the file to see bind
sudo nano /etc/mongod.conf
## change the bind to 
0.0.0.0
## save it 
# check if the bindIp has changed 
cat /etc/mongod.conf | grep bindIp
sudo systemctl restart mongod
sudo systemctl status mongodd
## should show as running 


## Manual validation and troubleshooting are suggested if issues arise.


# restart mongoDB to change configuration
sudo systemctl restart mongod

# make sure its enabled
echo enable mongod ...
sudo systemctl enable mongod 
echo done!

## Restart and Enable MongoDB
## Restarts MongoDB to apply the new configuration and enables it to start automatically on system boot.

#check the status 
sudo systemctl status mongod

## Verify MongoDB Status
## Checks the status of the MongoDB service to ensure it is running.

#### Final State
## MongoDB 7.0.6 is installed and running.
## The server is configured to accept connections from external IPs.
## MongoDB will automatically start on system boot.
## This script ensures a reliable MongoDB installation and configuration process, making the database ready for use in a production or development environment.