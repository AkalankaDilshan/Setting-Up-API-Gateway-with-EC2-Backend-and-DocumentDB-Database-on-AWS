#!/bin/bash

# Author: M.K.Akalanka Dilshan
# Date: 2025-01-15
# Time: 13.38

sudo yum update -y 

sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

echo "
<!DOCTYPE html>
<html>
     <head>
          <title> API and Load Balancer Test</title>
     </head>
     <body>
          <h2> private Backend server</h2>
     </body>
</html>" | sudo tee /var/www/html/index.html

sudo systemctl restart httpd