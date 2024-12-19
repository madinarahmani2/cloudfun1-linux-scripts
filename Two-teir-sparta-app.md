1.  Creating the Sparta App and Database VM 
     - /Users/dinar/Desktop/github/cloudfun1-linux-cloud/learn_azure_basics/scripts/setting.up.vm.md
     - should result in two VMs
     1.  cloudfun1-madina-uks-app
     2.  cloudfun1-madina-uks-database


2. Database scripts 
    - on the .ssh terminal insert into the database virtual machine and follow these commands on this pathway
        - scripts/provision-database.sh
    -  This should get you the "active running" status


3. App scripts 
   - on the .ssh terminal insert into the app virtual machine and follow these commands on this pathway 
        - scripts/provision-app-script.sh
    - once thhis script is ran the Environment Setup: Nginx, Node.js, and PM2 are installed and configured.
    - results : your application will be accessible via Nginx on port 80, with the backend handling requests on port 3000.


4. checking to see if the app is running
   - copy the public IP address from the app VM and paste it on a webserver 
   - add ":3000" the app should be running 
   - remove this 
   - paste the public IP and app should be running 
   - add "/posts" app should run with the databases


5. automate app deployment with userdata 
     1. create a new VM for the app 
     2. use the same exact steps as we did previosly 
     3. on the vm on the advanced page enable user data and paste this
           - scripts/user-data.sh
     4. this should take a while to deploy and run 
     5. copy the Public IP address and add ":3000" this should run the app
     6. ![alt text](<../images/Screenshot 2024-12-19 at 18.25.17.png>)
     7. add "/posts" and it should give the database
     8. ![alt text](<../images/Screenshot 2024-12-19 at 18.27.02.png>)

6. Automate app deployment using an image and abit of user data 
     




