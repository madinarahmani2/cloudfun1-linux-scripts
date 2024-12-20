1.  Creating the Sparta App VM and Database VM 

     - /Users/dinar/Desktop/github/cloudfun1-linux-cloud/learn_azure_basics/scripts/setting.up.vm.md
     - should result in two VMs
     1.  cloudfun1-madina-uks-app
     2.  cloudfun1-madina-uks-database


2. Database scripts 

    - on the .ssh directory on the terminal log into the database VM using its public IP address and the admin credentials you set up earlier.
        - scripts/provision-database.sh
    -  once completed MongoDB 7.0.6 is installed and running. The server is configured to accept connections from external IPs. This script ensures a reliable MongoDB installation and configuration process, making the database ready for use in a production or development environment.
    -  This should get you the "active running" status


3. App scripts 

connect to .ssh
   - on the .ssh directory on the terminal log into the app VM using its public IP address and the admin credentials you set up earlier.
   -  follow these commands on this pathway 
        - scripts/provision-app-script.sh
Script actions
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

1. Automating two-tier deployment 
   
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
     2. use the same exact steps as we did previosly 
     3. Go to the Advanced Settings during the VM creation process.Locate the User Data section.Paste the following script into the field:
           - scripts/user-data.sh
     4. Monitor the instance. Once the VM is running, the app setup and deployment process will complete automatically.
     5. opy the Public IP address of the VM from your cloud provider's dashboard.Open a web browser and enter the IP address followed by :3000.
     6. ![alt text](<../images/Screenshot 2024-12-19 at 18.25.17.png>)
     7. add "/posts" to the URL and it should give the database
     8. ![alt text](<../images/Screenshot 2024-12-19 at 18.27.02.png>)

7. App deployment using an image and abit of user data 

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

1. Database VM using images

    - Create a database image like we did for the app.
    - create a database VM as done previously. once it has been completed. capture this and save it as "cloudfun1-madina-database-image"
    - then create a new VM database and use that image we created
   - on advanced for user data add "sudo systemctl enable mongo"
   - Copy the Public IP Address of the new VM by accessing:
    App URL: http://<Public-IP>:3000
    Database URL: http://<Public-IP>:3000/posts