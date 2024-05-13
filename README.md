# PHP app with RDS and SNS

Sample PHP WebApp to store contact info.

The app uses [AWS RDS](https://aws.amazon.com/rds/) to store contact info.

## Target architecture

![Notifier](/images/target_architecture.png)

## Step-by-step

### **Create Network**

01. Login into AWS Console.

02. On **Services** type **VPC** and select the service.

03. Select **Create VPC** and complete with below parameters.

    - Resources to create: **VPC and more**
    - Auto-generate: **db**
    - IPv4 CIDR block: **30.0.0.0/16**
    - Number of Availability Zones (AZs): **2**
    - Customize AZs
      - First availability zone: **us-east-1a**
      - Second availability zone: **us-east-1b**
    - Number of public subnets: **2**
    - Number of private subnets: **2**
    - Customize subnets CIDR blocks
      - Public subnet CIDR block in us-east-1a: **30.0.1.0/24**
      - Public subnet CIDR block in us-east-1b: **30.0.3.0/24**
      - Private subnet CIDR block in us-east-1a: **30.0.2.0/24**
      - Private subnet CIDR block in us-east-1b: **30.0.4.0/24**
    - NAT gateways: **None**
    - VPC endpoints: **None**
    
04. Click **Create VPC**.

### **Create Firewall**

#### **Public Firewall**

01. On **Services** type **VPC** and select the service.

02. In the left side menu click **Security Groups**.

03. Click **Create security group** and complete with below parameters.

    - Security group name: **db-sg-pub**
    - Description: **DB Security Group public**
    - VPC: **db-vpc**
    - Inbound rules (Click **Add rule** for each rule below)
      - Rule 1
        - Type: **All traffic**
        - Source: **30.0.0.0/16**
      - Rule 2
        - Type: **HTTP**
        - Source: **0.0.0.0/0**
      - Rule 3
        - Type: **SSH**
        - Source: **0.0.0.0/0**

04. Click **Create security group**.

#### **Private Firewall**

01. On **Services** type **VPC** and select the service.

02. In the left side menu click **Security Groups**.

03. Click **Create security group** and complete with below parameters.

    - Security group name: **db-sg-priv**
    - Description: **DB Security Group private**
    - VPC: **db-vpc**
    - Inbound rules (Click **Add rule**)
      - Rule 1
        - Type: **All traffic**
        - Source: **30.0.0.0/16**

04. Click **Create security group**.

### **Create Database**

01. On **Services** type **RDS** and select the service.

#### **Create Subnet Group**

01. In the left panel menu click **Subnet groups**.

02. Click **Create DB subnet group** and complete with below parameters.

    - Name: **db-sn-group**
    - Description: **DB Subnet Group**
    - VPC: **db-vpc**
    - Availability Zones: **us-east-1a** and **us-east-1b**
    - Subnets: **30.0.2.0/24** and **30.0.4.0/24**

03. Click **Create**.

#### **Create Parameter Group**

01. In the left panel menu click **Parameter groups**.

02. Click **Create parameter group** and complete with below parameters.

    - Parameter group name: **db-param-group**
    - Description: **DB Parameter Group**
    - Engine Type: **MySQL Community Edition**
    - Parameter group family: **mysql8.0**

03. Click **Create**.

#### **Config Parameter Group for parameter character_set_server**

01. In the left panel menu click **Parameter groups**.

02. Click in the link **db-param-group**.

03. Click **Edit**.

04. In the **Filter Parameters** search field, type **character_set_server**.

05. In the **Value** field, type **utf8**.

06. Click **Save changes**.

#### **Config Parameter Group for parameter character_set_database**

01. In the left panel menu click **Parameter groups**.

02. Click in the link **db-param-group**.

03. Click **Edit**.

04. In the **Filter Parameters** search field, type **character_set_database**.

05. In the **Value** field, type **utf8**.

06. Click **Save changes**.

#### **Create database**

01. In the left panel menu click **Databases**.

02. Click **Create database** and complete with below parameters.

    - Engine options
      - Engine type: **MySQL**
    - Availability and durability
      - Deployment options: **Multi-AZ DB instance**
    - Settings
      - DB instance identifier: **db-instance-id**
      - Master username: **dbadmin**
      - Credentials management: **selected**
        - Self managed
        - Master password: **dbpassword**
        - Confirm master password: **dbpassword**
    - Instance configuration
      - DB instance class: **Burstable classes (includes t classes)**
    - Storage
      - Storage type : **gp2**
      - Storage autoscaling
        - Enable storage autoscaling: **disabled**
    - Connectivity
      - Virtual private cloud (VPC): **db-vpc**
      - DB subnet group: **db-sn-group**
      - Existing VPC security groups: **db-sg-priv**

        > **Note:** Remove the **default** security group if selected.

    - Monitoring
      - Enable Enhanced monitoring: **disabled**
    - Additional configuration
      - Initial database name: **dbname**
      - DB parameter group: **db-param-group**
      - Enable automated backups: **disabled**
      - Enable encryption: **disabled**
      - Enable auto minor version upgrade: **disabled**
      - Enable deletion protection: **disabled**

03. Click **Create database**.

    > **Note:** Validate database creation. Process should take 10-15 minutes. Wait until status is **Available**.

04. Click in the link with **db-instance-id** and capture the **Endpoint** value.

    > **Note:** It will be used on later steps.

### **Create Load Balancer with Autoscaling**

#### **Create EC2 Launch template**

01. On **Services** type **EC2** and select the service.

02. In the left panel menu, under **Instances**,  click **Launch Templates**.

04. Select **Create launch template** and complete with below parameters.

    - Launch template name : **ec2-launch-template**
    - Application and OS Images (Amazon Machine Image)
      - Quick start: **Amazon Linux**
      - Amazon Machine Image (AMI) : **Amazon Linux 2 AMI (HVM)**
    - Instance type : **t2.micro**
    - Key pair : **vockey** (or any from your choice)
    - Network Settings
      - Security groups : **db-sg-pub**
      - Advanced network configuration
        - Add network interface
          - Auto-assign public IP : **Enable**
    - Advanced details
      - User data - optional

        ```
        #!/bin/bash
        
        echo "Update/Install required OS packages"
        yum update -y
        amazon-linux-extras install -y php7.2 epel
        yum install -y httpd mysql php-mtdowling-jmespath-php php-xml telnet tree git
        
        echo "Config PHP app Connection to Database"
        cat <<EOT >> /var/www/config.php
        <?php
        define('DB_SERVER', 'RDS_ENDPOINT');
        define('DB_USERNAME', 'dbadmin');
        define('DB_PASSWORD', 'dbpassword');
        define('DB_DATABASE', 'dbname');
        ?>
        EOT
        
        echo "Deploy PHP app"
        cd /tmp
        git clone https://github.com/kledsonhugo/app-notifier
        cp /tmp/app-notifier/*.php /var/www/html/
        rm -rf /tmp/notifier
        
        echo "Config Apache WebServer"
        usermod -a -G apache ec2-user
        chown -R ec2-user:apache /var/www
        chmod 2775 /var/www
        find /var/www -type d -exec chmod 2775 {} \;
        find /var/www -type f -exec chmod 0664 {} \;
        
        echo "Start Apache WebServer"
        systemctl enable httpd
        service httpd restart
        ```

        > **Note:** Replace **RDS_ENDPOINT** with the value of the RDS service endpoint captured in previous steps.
    
05. Click **Create launch template**.

#### **Create EC2 Auto Scaling Group**

01. In the left panel menu, under **Auto Scaling**,  click **Auto Scaling Groups**.

02. Select **Create Auto Scaling group** and complete with below parameters.

    - Auto Scaling group name: **ec2-auto-scaling-group**
    - Launch template: **ec2-launch-template**

03. Click **Next**.

04. Complete with below parameters.

    - VPC: **db-vpc**
    - Availability Zones and subnets: **30.0.1.0/24** and **30.0.3.0/24**

05. Click **Next**.

06. Complete with below parameters.

    - Load balancing
      - **Attach to a new load balancer**
    - Attach to a new load balancer
      - Load balancer name: **ec2-load-balancer**
      - Load balancer scheme: **Internet-facing**
      - Listeners and routing
        - Default routing (forward to): **Create a target group**
        - New target group name: **ec2-target-group**

07. Click **Next**.

08. Complete with below parameters.

    - Group size
      - Desired capacity: **2**

09. Click **Next**.

10. Click **Next**.

11. Click **Next**.

12. Click **Create Auto Scaling group**.

#### **Config Load Balancer Security Group**

01. In the left panel menu, under **Load Balancing**,  click **Load Balancers**.

02. Click on **ec2-load-balancer** to open the Load Balancer page details.

03. Click in the **Security** menu.

04. Click **Edit**.

05. Remove the default Security Group and add **db-sg-pub**.

06. Click **Save Changes**.

#### **Validate Target Group**

01. In the left panel menu, under **Load Balancing**, click **Target Groups**.

02. Click on **ec2-target-group** and validate if 2 instances are **Healthy**.

    > **Note** The instance registration process takes 5-10 minutes.

#### **Validate Load Balancer**

01. In the left panel menu, under **Load Balancing**, click **Load Balancers**.

02. Click on **ec2-load-balancer** and capture the value for field **DNS name**.

03. Open a browser tab and navigate to **http://DNS_NAME**. Replace **DNS_NAME** with the value captured on previous step.

    > **Note:** You should see a page like the example below. Add a new contact to validate the PHP web application is adding data into RDS successfully.

      ![Notifier](/images/notifier.png)

## **Congratulations**

If you reach this point successfully, you completed the procedure.

Don´t forget to destroy all resources avoiding unnecessary costs.
