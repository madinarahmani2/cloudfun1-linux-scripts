## user data scripts for everything to work with our custom images we made
## when making a app virtual machine this is the user data youll need 
#!/bin/bash

cd /repo/app

echo "export DB_HOST=mongodb://10.0.3.4:27017/posts" >> ~/.bashrc

export DB_HOST=mongodb://10.0.3.4:27017/posts

npm install

pm2 start app.js



## when creating vm for database image 
## on userdata add 
sudo systemctl enable mongo
