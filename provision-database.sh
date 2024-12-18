#!/bin/bash


# sparta database vm 

## ubuntu 22.04
## vm network under my name
## ssh public key 
## private subnet 
## create new 
## add an inbound rule 80 and 3000
## add tags and review



# COMMANDS 

# update vm packages
sudo apt update -y

# upgrade packages
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

# install gnup and curl if not already installed 
sudo DEBIAN_FRONTEND=noninteractive apt-get install gnupg curl

# import mongodb public GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

# create mongoDB list file
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

# update the mongoDB package
sudo apt-get update

# download specific version of mongoDB
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

# prevent mongdb package from upgrading
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

# start MongoDB
sudo systemctl start mongod

# change config of mongod local ip to default gateway
sudo sed -i.bak 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf 


####   IF ERROR SHOWS 
# checking the file to see bind
sudo nano /etc/mongod.conf
## change the bind to 0.0.0.0
## save it 
# check if the bindIp has changed 
cat /etc/mongod.conf | grep bindIp
sudo systemctl restart mongod
sudo systemctl status mongodd
## should show as running 

# restart mongoDB to change configuration
sudo systemctl restart mongod

# make sure its enabled
echo enable mongod ...
sudo systemctl enable mongod 
echo done!

#check the status 
sudo systemctl status mongod