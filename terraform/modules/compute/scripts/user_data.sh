#!/bin/bash


# 1- Update/Install required OS packages
yum update -y
amazon-linux-extras install -y php7.2 epel
yum install -y httpd mysql php-mtdowling-jmespath-php php-xml telnet tree git


# 2- (Optional) Enable PHP to send AWS SNS events
# NOTE: If uncommented, more configs are required
# - Step 4: Deploy PHP app
# - Module Compute: compute.tf and vars.tf manifests

# 2.1- Config AWS SDK for PHP
# mkdir -p /opt/aws/sdk/php/
# cd /opt/aws/sdk/php/
# wget https://docs.aws.amazon.com/aws-sdk-php/v3/download/aws.zip
# unzip aws.zip

# 2.2- Config AWS Account
# mkdir -p /var/www/html/.aws/
# cat <<EOT >> /var/www/html/.aws/credentials
# [default]
# aws_access_key_id=12345
# aws_secret_access_key=12345
# aws_session_token=12345
# EOT


# 3- Config PHP app Connection to Database
cat <<EOT >> /var/www/config.php
<?php
define('DB_SERVER', '${rds_endpoint}');
define('DB_USERNAME', '${rds_dbuser}');
define('DB_PASSWORD', '${rds_dbpassword}');
define('DB_DATABASE', '${rds_dbname}');
?>
EOT


# 4- Deploy PHP app
cd /tmp
git clone https://github.com/kledsonhugo/notifier
cp /tmp/notifier/app/*.php /var/www/html/
# mv /var/www/html/sendsms.php /var/www/html/index.php
rm -rf /tmp/notifier


# 5- Config Apache WebServer
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;


# 6- Start Apache WebServer
systemctl enable httpd
service httpd restart