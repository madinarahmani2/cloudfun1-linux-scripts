1.  Creating the Sparta App VM and Database VM 
     - /Users/dinar/Desktop/github/cloudfun1-linux-cloud/learn_azure_basics/scripts/setting.up.vm.md
     - should result in two VMs
     1.  cloudfun1-madina-uks-app
     2.  cloudfun1-madina-uks-database


2. Database scripts 
    - on the .ssh terminal insert into the database virtual machine and follow these commands on this pathway
        - scripts/provision-database.sh
    -  MongoDB 7.0.6 is installed and running. The server is configured to accept connections from external IPs. This script ensures a reliable MongoDB installation and configuration process, making the database ready for use in a production or development environment.
    -  This should get you the "active running" status


3. App scripts 
   - on the .ssh terminal insert into the app virtual machine and follow these commands on this pathway 
        - scripts/provision-app-script.sh
    - once thhis script is ran the Environment Setup: Nginx, Node.js, and PM2 are installed and configured.
    - results : your application will be accessible via Nginx on port 80, with the backend handling requests on port 3000.

4. Automating two-tier deployment 
- The deployment is fully automated with:
     - Database Script: Sets up and configures MongoDB.
     - App Script: Configures the application tier with Nginx, Node.js, and the app itself.
     - User Data: Runs the app script automatically on instance creation, ensuring immediate deployment.

5. Checking to see if the app is running and database
   - copy the public IP address from the app VM and paste it on a webserver 
   - add ":3000" the app should be running 
   - remove this 
   - paste the public IP and app should be running 
   - add "/posts" app should run with the databases


6. Automate app deployment with userdata 
     1. create a new VM for the app 
     2. use the same exact steps as we did previosly 
     3. on the vm on the advanced page enable user data and paste this script
           - scripts/user-data.sh
     4. this should take a while to deploy and run 
     5. copy the Public IP address and add ":3000" this should run the app
     6. ![alt text](<../images/Screenshot 2024-12-19 at 18.25.17.png>)
     7. add "/posts" and it should give the database
     8. ![alt text](<../images/Screenshot 2024-12-19 at 18.27.02.png>)

7. App deployment using an image and abit of user data 
     - we need to create a new app Vm exactly how we did with the user data, however as an image instead of UBUNTU 220.04 we use "ramon-ubuntu"
     - once the VM is created we then capture that vm and create an image. 
     - "cloudfun-madina-app-image"
     - then we have to test that image we created. 
     - create a new VM using "cloudfun-madina-app-image" and on the user data paste this script 
          -learn_azure_basics/scripts/user-data-images.sh
    - once the public IP has been pasted on a web server with ":3000" and "/posts" everything shall be running. 

8. Database VM using images
    - Create a database image like we did for the app.
    - once we have completed this, we must create a new database VM using that image and on the user data add "sudo systemctl enable mongo"
    - this port should open ":3000" and "/posts"
  

  




