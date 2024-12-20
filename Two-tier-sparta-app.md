1.  Creating the Sparta App VM and Database VM 

     - /Users/dinar/Desktop/github/cloudfun1-linux-cloud/learn_azure_basics/scripts/setting.up.vm.md
     - should result in two VMs
     1.  cloudfun1-madina-uks-app
     2.  cloudfun1-madina-uks-database


2. Database scripts 

    - on the .ssh directory on the terminal log into the database VM using its public IP address and the admin credentials you set up earlier.
        - scripts/provision-database.sh

What This Script Does 
This Bash script automates the installation, configuration, and setup of MongoDB (version 7.0.6) on an Ubuntu-based virtual machine. Below is a step-by-step explanation of each section and what you can expect when the script runs.

```bash
#!/bin/bash

# Update VM packages
sudo apt update -y

# Upgrade packages
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

## Update and Upgrade Packages
## Ensures the system is up-to-date by updating the package index and upgrading installed packages.

# Install gnupg and curl if not already installed
sudo DEBIAN_FRONTEND=noninteractive apt-get install gnupg curl

### Install Dependencies
### Installs gnupg and curl if they are not already present. These tools are required to fetch and verify the MongoDB public GPG key.

# Import MongoDB public GPG key
curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | \
   sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg \
   --dearmor

### Import MongoDB Public GPG Key
### Imports the official MongoDB GPG key for package verification and saves it in a secure location.

# Create MongoDB list file
echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

## Set Up MongoDB Repository
## Adds the MongoDB repository to the system’s sources list for package installation.

# Update the MongoDB package
sudo apt-get update

# Download specific version of MongoDB
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mongodb-org=7.0.6 mongodb-org-database=7.0.6 mongodb-org-server=7.0.6 mongodb-mongosh mongodb-org-mongos=7.0.6 mongodb-org-tools=7.0.6

## Install MongoDB Version 7.0.6
## Updates the package list and installs the specified version of MongoDB along with its components.

# Prevent MongoDB package from upgrading
echo "mongodb-org hold" | sudo dpkg --set-selections
echo "mongodb-org-database hold" | sudo dpkg --set-selections
echo "mongodb-org-server hold" | sudo dpkg --set-selections
echo "mongodb-mongosh hold" | sudo dpkg --set-selections
echo "mongodb-org-mongos hold" | sudo dpkg --set-selections
echo "mongodb-org-tools hold" | sudo dpkg --set-selections

## Prevent Package Upgrades
## Prevents MongoDB packages from being upgraded automatically to newer versions.

# Start MongoDB
sudo systemctl start mongod

## Start MongoDB
## Starts the MongoDB service.

# Change config of mongod local IP to default gateway
sudo sed -i.bak 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

## Configure MongoDB to Listen on All IPs
## Updates MongoDB’s bindIp configuration to allow connections from any IP address.

#### If Error Shows
# Check the file to see bind
sudo nano /etc/mongod.conf

## Change the bind to 
0.0.0.0

## Save it

# Check if the bindIp has changed
cat /etc/mongod.conf | grep bindIp
sudo systemctl restart mongod
sudo systemctl status mongod

## Should show as running

## Manual validation and troubleshooting are suggested if issues arise.

# Restart MongoDB to change configuration
sudo systemctl restart mongod

# Make sure it's enabled
echo "Enabling MongoDB service..."
sudo systemctl enable mongod
echo "Done!"

## Restart and Enable MongoDB
## Restarts MongoDB to apply the new configuration and enables it to start automatically on system boot.

# Check the status
sudo systemctl status mongod

## Verify MongoDB Status
## Checks the status of the MongoDB service to ensure it is running.

#### Final State
## MongoDB 7.0.6 is installed and running.
## The server is configured to accept connections from external IPs.
## MongoDB will automatically start on system boot.
## This script ensures a reliable MongoDB installation and configuration process, making the database ready for use in a production or development environment.
```

 -  once completed MongoDB 7.0.6 is installed and running. The server is configured to accept connections from external IPs. This script ensures a reliable MongoDB installation and configuration process, making the database ready for use in a production or development environment.
    -  This should get you the "active running" status


3. App scripts 

connect to .ssh
   - on the .ssh directory on the terminal log into the app VM using its public IP address and the admin credentials you set up earlier. 
   - ssh -i ~/.ssh/<private-key-file> <admin-username>@<database-vm-public-ip>

   -  follow these commands on this pathway 
        - scripts/provision-app-script.sh

What This Script Does
This Bash script automates the installation and setup of a Node.js application with MongoDB, Nginx as a reverse proxy, and PM2 as a process manager. Here's a step-by-step breakdown of what happens:


```bash
#!/bin/bash

# Update system packages
echo "Updating system packages..."
sudo apt update -y

# Upgrade system packages
echo "Upgrading system packages..."
sudo DEBIAN_FRONTEND=noninteractive apt upgrade -y

## Ensures that all system packages are up-to-date and upgraded.

# Install Nginx
echo "Installing Nginx..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install nginx -y

## Installs the Nginx web server, which will be configured as a reverse proxy.

# Download Node.js setup script
echo "Downloading Node.js setup script..."
curl -fsSL https://deb.nodesource.com/setup_20.x -o setup_nodejs.sh

## Downloads the Node.js setup script for version 20.x and executes it to add the repository.

# Run the Node.js setup script
echo "Setting up Node.js..."
sudo DEBIAN_FRONTEND=noninteractive bash setup_nodejs.sh

# Install Node.js
echo "Installing Node.js..."
sudo DEBIAN_FRONTEND=noninteractive apt-get install nodejs -y

## Installs Node.js from the added repository.

# Configure Nginx as a reverse proxy
echo "Configuring Nginx as a reverse proxy..."
sudo sed -i 's|try_files.*;|proxy_pass http://localhost:3000/;|' /etc/nginx/sites-available/default
sudo systemctl reload nginx
sudo systemctl restart nginx

## Modifies the default Nginx configuration to set up a reverse proxy to redirect requests to http://localhost:3000/ (the application server).

# Clone the application repository
echo "Cloning the application repository..."
git clone https://github.com/daraymonsta/tech201-sparta-app /repo

## Clones the specified GitHub repository to /repo.

# Navigate to the application directory
echo "Navigating to the application directory..."
cd /repo/app || { echo "Application directory not found. Exiting."; exit 1; }

# Export the MongoDB connection string
echo "Setting up MongoDB connection string..."
export DB_HOST=mongodb://10.0.3.4:27017/posts

## Exports the MongoDB connection string for the application to use.

# Install PM2 process manager
echo "Installing PM2..."
sudo npm install -g pm2

## Installs the PM2 process manager globally to manage the application process.

# Install application dependencies
echo "Installing application dependencies..."
npm install

# Populate the database
echo "Populating the database..."
node seeds/seed.js

## Seeds the database with initial data.

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
```

**Script actions**
    - Installs Nginx:
      Nginx is installed and configured as a reverse proxy.
      It forwards HTTP requests (on port 80) to the backend application running on port 3000.
    - Installs Node.js:
      Node.js is installed to run the backend application.
    - Installs PM2:
      PM2 is installed to manage the Node.js application as a process, ensuring it runs continuously and restarts on crashes.
    - Configures Nginx:
      Nginx is configured to serve the frontend and proxy backend requests. 
    - results : your application will be accessible via Nginx on port 80, with the backend handling requests on port 3000.

4. Automating two-tier deployment 
   
- The deployment is fully automated with:
     - Database Script: Sets up and configures MongoDB.
     - App Script: Configures the application tier with Nginx, Node.js, and the app itself.
     - User Data: Runs the app script automatically on instance creation, ensuring immediate deployment.

5. Checking to see if the app is running and database

   -Copy the Public IP Address of the new VM by accessing:
    App URL: http://<Public-IP>:3000
    Database URL: http://<Public-IP>:3000/posts


6. Automate app deployment with userdata 
   
userdata is often provided during instance launch to customize the instance and automate tasks without manual intervention.
     1. create a new VM for the app 
     2. Use the same configurations as your previous VM setup 
     3. During the VM creation process, go to the Advanced Settings section.
        Locate the User Data field.
        Paste the contents of scripts/user-data.sh into this field. The script will automate the app setup during instance boot.
           - scripts/user-data.sh

## This is for the user data when you have a fresh new VM for app

```bash
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
```

     4. Once the VM is running, the userdata script will execute automatically to set up and      deploy the app.
            Check the instance logs if needed to ensure the script runs without errors.
     5. Copy the Public IP address of the VM from your cloud provider's dashboard.Open a web browser and enter the IP address followed by :3000.
     6. ![alt text](<../images/Screenshot 2024-12-19 at 18.25.17.png>)
     7. add "/posts" to the URL and it should give the database
     8. ![alt text](<../images/Screenshot 2024-12-19 at 18.27.02.png>)
     9.  Copy the Public IP Address of the new VM by accessing:
    App URL: http://<Public-IP>:3000
    Database URL: http://<Public-IP>:3000/posts

7 . App deployment using an image and abit of user data 
A custom image is a reusable VM image derived from an existing VM. It consists of an operating system, disc settings, installed software, and any particular customisations. These images are often used to duplicate a pre-configured environment across numerous virtual machines.

     - we need to create a new app Vm exactly how we did with the user data, however as an image instead of UBUNTU 220.04 we use "ramon-ubuntu"
     - once the VM is created we then capture that VM and create an image. // this duplicates the pre configured enviroment. 
     - name the image "cloudfun-madina-app-image"
     - then we have to test that image we created to ensure that we have acptured it correctlt
     - create a new VM using "cloudfun-madina-app-image" and on the user data paste this script 
          -learn_azure_basics/scripts/user-data-images.sh
    - Copy the Public IP Address of the new VM.Test the app by accessing:
    App URL: http://<Public-IP>:3000
    Database URL: http://<Public-IP>:3000/posts

8. Database VM using images

    - Create a database image like we did for the app.
    - create a database VM as done previously. once it has been completed. capture this and save it as "cloudfun1-madina-database-image"
    - then create a new VM database and use that image we created
   - on advanced for user data add "sudo systemctl enable mongo"
   - Copy the Public IP Address of the new VM by accessing:
    App URL: http://<Public-IP>:3000
    Database URL: http://<Public-IP>:3000/posts