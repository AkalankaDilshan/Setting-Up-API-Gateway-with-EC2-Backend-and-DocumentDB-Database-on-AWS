#!/bin/bash

# Author: M.K.Akalanka Dilshan
# Date: 2025-01-15
# Time: 13.38

sudo yum update -y 

sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

# Fetch the Availability Zone of the EC2 instance
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

echo "
<!DOCTYPE html>
<html>
     <head>
          <title> API and Load Balancer Test</title>
     </head>
     <body>
          <h1>I'm in the $AZ Availability Zone</h1>
     </body>
</html>" | sudo tee /var/www/html/index.html

sudo systemctl restart httpd