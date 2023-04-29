#  IaC - Checkpoint 3 - Felipe Gomes de Souza Filho



<div>
<br>
<h2>   Terraform Plan Atualizado
</div>

```
PS C:\Users\FelipeGomesdeSouzaFi\Desktop\app-notifier\terraform> terraform plan -input=false -out tfplan  

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # module.compute.data.template_file.user_data will be read during apply
  # (config refers to values not yet known)
 <= data "template_file" "user_data" {
      + id       = (known after apply)
      + rendered = (known after apply)
      + template = <<-EOT
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
        EOT
      + vars     = {
          + "rds_dbname"     = "rdsdbfelipe"
          + "rds_dbpassword" = "rdsdbadminpwd"
          + "rds_dbuser"     = "rdsdbadmin"
        }
    }

  # module.compute.aws_autoscaling_group.ec2_asg will be created
  + resource "aws_autoscaling_group" "ec2_asg" {
      + arn                       = (known after apply)
      + availability_zones        = (known after apply)
      + default_cooldown          = (known after apply)
      + desired_capacity          = 4
      + force_delete              = false
      + force_delete_warm_pool    = false
      + health_check_grace_period = 300
      + health_check_type         = (known after apply)
      + id                        = (known after apply)
      + max_size                  = 8
      + metrics_granularity       = "1Minute"
      + min_size                  = 2
      + name                      = "ec2-asg-felipe"
      + name_prefix               = (known after apply)
      + protect_from_scale_in     = false
      + service_linked_role_arn   = (known after apply)
      + target_group_arns         = (known after apply)
      + vpc_zone_identifier       = (known after apply)
      + wait_for_capacity_timeout = "10m"

      + launch_template {
          + id      = (known after apply)
          + name    = (known after apply)
          + version = "$Latest"
        }
    }

  # module.compute.aws_launch_template.ec2_lt will be created
  + resource "aws_launch_template" "ec2_lt" {
      + arn                    = (known after apply)
      + default_version        = (known after apply)
      + id                     = (known after apply)
      + image_id               = "ami-069aabeee6f53e7bf"
      + instance_type          = "t2.micro"
      + key_name               = "vockey"
      + latest_version         = (known after apply)
      + name                   = "ec2-lt-felipe"
      + name_prefix            = (known after apply)
      + tags_all               = (known after apply)
      + user_data              = (known after apply)
      + vpc_security_group_ids = (known after apply)
    }

  # module.compute.aws_lb.ec2_lb will be created
  + resource "aws_lb" "ec2_lb" {
      + arn                                         = (known after apply)
      + arn_suffix                                  = (known after apply)
      + desync_mitigation_mode                      = "defensive"
      + dns_name                                    = (known after apply)
      + drop_invalid_header_fields                  = false
      + enable_deletion_protection                  = false
      + enable_http2                                = true
      + enable_tls_version_and_cipher_suite_headers = false
      + enable_waf_fail_open                        = false
      + enable_xff_client_port                      = false
      + id                                          = (known after apply)
      + idle_timeout                                = 60
      + internal                                    = (known after apply)
      + ip_address_type                             = (known after apply)
      + load_balancer_type                          = "application"
      + name                                        = "ec2-lb-felipe"
      + preserve_host_header                        = false
      + security_groups                             = (known after apply)
      + subnets                                     = (known after apply)
      + tags_all                                    = (known after apply)
      + vpc_id                                      = (known after apply)
      + xff_header_processing_mode                  = "append"
      + zone_id                                     = (known after apply)
    }

  # module.compute.aws_lb_listener.ec2_lb_listener will be created
  + resource "aws_lb_listener" "ec2_lb_listener" {
      + arn               = (known after apply)
      + id                = (known after apply)
      + load_balancer_arn = (known after apply)
      + port              = 80
      + protocol          = "HTTP"
      + ssl_policy        = (known after apply)
      + tags_all          = (known after apply)

      + default_action {
          + order            = (known after apply)
          + target_group_arn = (known after apply)
          + type             = "forward"
        }
    }

  # module.compute.aws_lb_target_group.ec2_lb_tg will be created
  + resource "aws_lb_target_group" "ec2_lb_tg" {
      + arn                                = (known after apply)
      + arn_suffix                         = (known after apply)
      + connection_termination             = false
      + deregistration_delay               = "300"
      + id                                 = (known after apply)
      + ip_address_type                    = (known after apply)
      + lambda_multi_value_headers_enabled = false
      + load_balancing_algorithm_type      = (known after apply)
      + load_balancing_cross_zone_enabled  = (known after apply)
      + name                               = "ec2-lb-tg-felipe"
      + port                               = 80
      + preserve_client_ip                 = (known after apply)
      + protocol                           = "HTTP"
      + protocol_version                   = (known after apply)
      + proxy_protocol_v2                  = false
      + slow_start                         = 0
      + tags_all                           = (known after apply)
      + target_type                        = "instance"
      + vpc_id                             = (known after apply)
    }

  # module.database.aws_db_instance.rds_dbinstance will be created
  + resource "aws_db_instance" "rds_dbinstance" {
      + address                               = (known after apply)
      + allocated_storage                     = 20
      + apply_immediately                     = false
      + arn                                   = (known after apply)
      + auto_minor_version_upgrade            = true
      + availability_zone                     = (known after apply)
      + backup_retention_period               = (known after apply)
      + backup_window                         = (known after apply)
      + ca_cert_identifier                    = (known after apply)
      + character_set_name                    = (known after apply)
      + copy_tags_to_snapshot                 = false
      + db_name                               = "rdsdbfelipe"
      + db_subnet_group_name                  = "rds-sn-group-felipe"
      + delete_automated_backups              = true
      + endpoint                              = (known after apply)
      + engine                                = "mysql"
      + engine_version                        = "8.0.23"
      + engine_version_actual                 = (known after apply)
      + hosted_zone_id                        = (known after apply)
      + id                                    = (known after apply)
      + identifier                            = "rds-felipe"
      + identifier_prefix                     = (known after apply)
      + instance_class                        = "db.t2.micro"
      + iops                                  = (known after apply)
      + kms_key_id                            = (known after apply)
      + latest_restorable_time                = (known after apply)
      + license_model                         = (known after apply)
      + listener_endpoint                     = (known after apply)
      + maintenance_window                    = (known after apply)
      + master_user_secret                    = (known after apply)
      + master_user_secret_kms_key_id         = (known after apply)
      + max_allocated_storage                 = 0
      + monitoring_interval                   = 0
      + monitoring_role_arn                   = (known after apply)
      + multi_az                              = false
      + name                                  = (known after apply)
      + nchar_character_set_name              = (known after apply)
      + network_type                          = (known after apply)
      + option_group_name                     = (known after apply)
      + parameter_group_name                  = "rds-param-group-felipe"
      + password                              = (sensitive value)
      + performance_insights_enabled          = false
      + performance_insights_kms_key_id       = (known after apply)
      + performance_insights_retention_period = (known after apply)
      + port                                  = (known after apply)
      + publicly_accessible                   = false
      + replica_mode                          = (known after apply)
      + replicas                              = (known after apply)
      + resource_id                           = (known after apply)
      + skip_final_snapshot                   = true
      + snapshot_identifier                   = (known after apply)
      + status                                = (known after apply)
      + storage_throughput                    = (known after apply)
      + storage_type                          = "gp2"
      + tags_all                              = (known after apply)
      + timezone                              = (known after apply)
      + username                              = "rdsdbadmin"
      + vpc_security_group_ids                = (known after apply)
    }

  # module.database.aws_db_parameter_group.rds_param_group will be created
  + resource "aws_db_parameter_group" "rds_param_group" {
      + arn         = (known after apply)
      + description = "Managed by Terraform"
      + family      = "mysql8.0"
      + id          = (known after apply)
      + name        = "rds-param-group-felipe"
      + name_prefix = (known after apply)
      + tags_all    = (known after apply)

      + parameter {
          + apply_method = "immediate"
          + name         = "character_set_database"
          + value        = "utf8"
        }
      + parameter {
          + apply_method = "immediate"
          + name         = "character_set_server"
          + value        = "utf8"
        }
    }

  # module.database.aws_db_subnet_group.rds_sn_group will be created
  + resource "aws_db_subnet_group" "rds_sn_group" {
      + arn                     = (known after apply)
      + description             = "Managed by Terraform"
      + id                      = (known after apply)
      + name                    = "rds-sn-group-felipe"
      + name_prefix             = (known after apply)
      + subnet_ids              = (known after apply)
      + supported_network_types = (known after apply)
      + tags_all                = (known after apply)
      + vpc_id                  = (known after apply)
    }

  # module.network.aws_internet_gateway.igw will be created
  + resource "aws_internet_gateway" "igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags_all = (known after apply)
      + vpc_id   = (known after apply)
    }

  # module.network.aws_route_table.rt_priv will be created
  + resource "aws_route_table" "rt_priv" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags_all         = (known after apply)
      + vpc_id           = (known after apply)
    }

  # module.network.aws_route_table.rt_pub will be created
  + resource "aws_route_table" "rt_pub" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + instance_id                = ""
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags_all         = (known after apply)
      + vpc_id           = (known after apply)
    }

  # module.network.aws_route_table_association.rt_pub_sn_priv_az1 will be created
  + resource "aws_route_table_association" "rt_pub_sn_priv_az1" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_route_table_association.rt_pub_sn_priv_az2 will be created
  + resource "aws_route_table_association" "rt_pub_sn_priv_az2" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_route_table_association.rt_pub_sn_pub_az1 will be created
  + resource "aws_route_table_association" "rt_pub_sn_pub_az1" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_route_table_association.rt_pub_sn_pub_az2 will be created
  + resource "aws_route_table_association" "rt_pub_sn_pub_az2" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_security_group.vpc_sg_priv will be created
  + resource "aws_security_group" "vpc_sg_priv" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "30.0.0.0/16",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # module.network.aws_security_group.vpc_sg_pub will be created
  + resource "aws_security_group" "vpc_sg_pub" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
          + {
              + cidr_blocks      = [
                  + "30.0.0.0/16",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # module.network.aws_subnet.sn_priv_az1 will be created
  + resource "aws_subnet" "sn_priv_az1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "30.0.3.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_subnet.sn_priv_az2 will be created
  + resource "aws_subnet" "sn_priv_az2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "30.0.4.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_subnet.sn_pub_az1 will be created
  + resource "aws_subnet" "sn_pub_az1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "30.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_subnet.sn_pub_az2 will be created
  + resource "aws_subnet" "sn_pub_az2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "30.0.2.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_vpc.vpc will be created
  + resource "aws_vpc" "vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "30.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags_all                             = (known after apply)
    }

Plan: 22 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"

```

<div>
<br>
<h2>   Terraform Apply Atualizado
</div>

```
PS C:\Users\FelipeGomesdeSouzaFi\Desktop\app-notifier\terraform> terraform plan -input=false -out tfplan  

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
 <= read (data resources)

Terraform will perform the following actions:

  # module.compute.data.template_file.user_data will be read during apply
  # (config refers to values not yet known)
 <= data "template_file" "user_data" {
      + id       = (known after apply)
      + rendered = (known after apply)
      + template = <<-EOT
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
        EOT
      + vars     = {
          + "rds_dbname"     = "rdsdbfelipe"
          + "rds_dbpassword" = "rdsdbadminpwd"
          + "rds_dbuser"     = "rdsdbadmin"
        }
    }

  # module.compute.aws_autoscaling_group.ec2_asg will be created
  + resource "aws_autoscaling_group" "ec2_asg" {
      + arn                       = (known after apply)
      + availability_zones        = (known after apply)
      + default_cooldown          = (known after apply)
      + desired_capacity          = 4
      + force_delete              = false
      + force_delete_warm_pool    = false
      + health_check_grace_period = 300
      + health_check_type         = (known after apply)
      + id                        = (known after apply)
      + max_size                  = 8
      + metrics_granularity       = "1Minute"
      + min_size                  = 2
      + name                      = "ec2-asg-felipe"
      + name_prefix               = (known after apply)
      + protect_from_scale_in     = false
      + service_linked_role_arn   = (known after apply)
      + target_group_arns         = (known after apply)
      + vpc_zone_identifier       = (known after apply)
      + wait_for_capacity_timeout = "10m"

      + launch_template {
          + id      = (known after apply)
          + name    = (known after apply)
          + version = "$Latest"
        }
    }

  # module.compute.aws_launch_template.ec2_lt will be created
  + resource "aws_launch_template" "ec2_lt" {
      + arn                    = (known after apply)
      + default_version        = (known after apply)
      + id                     = (known after apply)
      + image_id               = "ami-069aabeee6f53e7bf"
      + instance_type          = "t2.micro"
      + key_name               = "vockey"
      + latest_version         = (known after apply)
      + name                   = "ec2-lt-felipe"
      + name_prefix            = (known after apply)
      + tags_all               = (known after apply)
      + user_data              = (known after apply)
      + vpc_security_group_ids = (known after apply)
    }

  # module.compute.aws_lb.ec2_lb will be created
  + resource "aws_lb" "ec2_lb" {
      + arn                                         = (known after apply)
      + arn_suffix                                  = (known after apply)
      + desync_mitigation_mode                      = "defensive"
      + dns_name                                    = (known after apply)
      + drop_invalid_header_fields                  = false
      + enable_deletion_protection                  = false
      + enable_http2                                = true
      + enable_tls_version_and_cipher_suite_headers = false
      + enable_waf_fail_open                        = false
      + enable_xff_client_port                      = false
      + id                                          = (known after apply)
      + idle_timeout                                = 60
      + internal                                    = (known after apply)
      + ip_address_type                             = (known after apply)
      + load_balancer_type                          = "application"
      + name                                        = "ec2-lb-felipe"
      + preserve_host_header                        = false
      + security_groups                             = (known after apply)
      + subnets                                     = (known after apply)
      + tags_all                                    = (known after apply)
      + vpc_id                                      = (known after apply)
      + xff_header_processing_mode                  = "append"
      + zone_id                                     = (known after apply)
    }

  # module.compute.aws_lb_listener.ec2_lb_listener will be created
  + resource "aws_lb_listener" "ec2_lb_listener" {
      + arn               = (known after apply)
      + id                = (known after apply)
      + load_balancer_arn = (known after apply)
      + port              = 80
      + protocol          = "HTTP"
      + ssl_policy        = (known after apply)
      + tags_all          = (known after apply)

      + default_action {
          + order            = (known after apply)
          + target_group_arn = (known after apply)
          + type             = "forward"
        }
    }

  # module.compute.aws_lb_target_group.ec2_lb_tg will be created
  + resource "aws_lb_target_group" "ec2_lb_tg" {
      + arn                                = (known after apply)
      + arn_suffix                         = (known after apply)
      + connection_termination             = false
      + deregistration_delay               = "300"
      + id                                 = (known after apply)
      + ip_address_type                    = (known after apply)
      + lambda_multi_value_headers_enabled = false
      + load_balancing_algorithm_type      = (known after apply)
      + load_balancing_cross_zone_enabled  = (known after apply)
      + name                               = "ec2-lb-tg-felipe"
      + port                               = 80
      + preserve_client_ip                 = (known after apply)
      + protocol                           = "HTTP"
      + protocol_version                   = (known after apply)
      + proxy_protocol_v2                  = false
      + slow_start                         = 0
      + tags_all                           = (known after apply)
      + target_type                        = "instance"
      + vpc_id                             = (known after apply)
    }

  # module.database.aws_db_instance.rds_dbinstance will be created
  + resource "aws_db_instance" "rds_dbinstance" {
      + address                               = (known after apply)
      + allocated_storage                     = 20
      + apply_immediately                     = false
      + arn                                   = (known after apply)
      + auto_minor_version_upgrade            = true
      + availability_zone                     = (known after apply)
      + backup_retention_period               = (known after apply)
      + backup_window                         = (known after apply)
      + ca_cert_identifier                    = (known after apply)
      + character_set_name                    = (known after apply)
      + copy_tags_to_snapshot                 = false
      + db_name                               = "rdsdbfelipe"
      + db_subnet_group_name                  = "rds-sn-group-felipe"
      + delete_automated_backups              = true
      + endpoint                              = (known after apply)
      + engine                                = "mysql"
      + engine_version                        = "8.0.23"
      + engine_version_actual                 = (known after apply)
      + hosted_zone_id                        = (known after apply)
      + id                                    = (known after apply)
      + identifier                            = "rds-felipe"
      + identifier_prefix                     = (known after apply)
      + instance_class                        = "db.t2.micro"
      + iops                                  = (known after apply)
      + kms_key_id                            = (known after apply)
      + latest_restorable_time                = (known after apply)
      + license_model                         = (known after apply)
      + listener_endpoint                     = (known after apply)
      + maintenance_window                    = (known after apply)
      + master_user_secret                    = (known after apply)
      + master_user_secret_kms_key_id         = (known after apply)
      + max_allocated_storage                 = 0
      + monitoring_interval                   = 0
      + monitoring_role_arn                   = (known after apply)
      + multi_az                              = false
      + name                                  = (known after apply)
      + nchar_character_set_name              = (known after apply)
      + network_type                          = (known after apply)
      + option_group_name                     = (known after apply)
      + parameter_group_name                  = "rds-param-group-felipe"
      + password                              = (sensitive value)
      + performance_insights_enabled          = false
      + performance_insights_kms_key_id       = (known after apply)
      + performance_insights_retention_period = (known after apply)
      + port                                  = (known after apply)
      + publicly_accessible                   = false
      + replica_mode                          = (known after apply)
      + replicas                              = (known after apply)
      + resource_id                           = (known after apply)
      + skip_final_snapshot                   = true
      + snapshot_identifier                   = (known after apply)
      + status                                = (known after apply)
      + storage_throughput                    = (known after apply)
      + storage_type                          = "gp2"
      + tags_all                              = (known after apply)
      + timezone                              = (known after apply)
      + username                              = "rdsdbadmin"
      + vpc_security_group_ids                = (known after apply)
    }

  # module.database.aws_db_parameter_group.rds_param_group will be created
  + resource "aws_db_parameter_group" "rds_param_group" {
      + arn         = (known after apply)
      + description = "Managed by Terraform"
      + family      = "mysql8.0"
      + id          = (known after apply)
      + name        = "rds-param-group-felipe"
      + name_prefix = (known after apply)
      + tags_all    = (known after apply)

      + parameter {
          + apply_method = "immediate"
          + name         = "character_set_database"
          + value        = "utf8"
        }
      + parameter {
          + apply_method = "immediate"
          + name         = "character_set_server"
          + value        = "utf8"
        }
    }

  # module.database.aws_db_subnet_group.rds_sn_group will be created
  + resource "aws_db_subnet_group" "rds_sn_group" {
      + arn                     = (known after apply)
      + description             = "Managed by Terraform"
      + id                      = (known after apply)
      + name                    = "rds-sn-group-felipe"
      + name_prefix             = (known after apply)
      + subnet_ids              = (known after apply)
      + supported_network_types = (known after apply)
      + tags_all                = (known after apply)
      + vpc_id                  = (known after apply)
    }

  # module.network.aws_internet_gateway.igw will be created
  + resource "aws_internet_gateway" "igw" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags_all = (known after apply)
      + vpc_id   = (known after apply)
    }

  # module.network.aws_route_table.rt_priv will be created
  + resource "aws_route_table" "rt_priv" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = (known after apply)
      + tags_all         = (known after apply)
      + vpc_id           = (known after apply)
    }

  # module.network.aws_route_table.rt_pub will be created
  + resource "aws_route_table" "rt_pub" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + carrier_gateway_id         = ""
              + cidr_block                 = "0.0.0.0/0"
              + core_network_arn           = ""
              + destination_prefix_list_id = ""
              + egress_only_gateway_id     = ""
              + gateway_id                 = (known after apply)
              + instance_id                = ""
              + ipv6_cidr_block            = ""
              + local_gateway_id           = ""
              + nat_gateway_id             = ""
              + network_interface_id       = ""
              + transit_gateway_id         = ""
              + vpc_endpoint_id            = ""
              + vpc_peering_connection_id  = ""
            },
        ]
      + tags_all         = (known after apply)
      + vpc_id           = (known after apply)
    }

  # module.network.aws_route_table_association.rt_pub_sn_priv_az1 will be created
  + resource "aws_route_table_association" "rt_pub_sn_priv_az1" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_route_table_association.rt_pub_sn_priv_az2 will be created
  + resource "aws_route_table_association" "rt_pub_sn_priv_az2" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_route_table_association.rt_pub_sn_pub_az1 will be created
  + resource "aws_route_table_association" "rt_pub_sn_pub_az1" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_route_table_association.rt_pub_sn_pub_az2 will be created
  + resource "aws_route_table_association" "rt_pub_sn_pub_az2" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # module.network.aws_security_group.vpc_sg_priv will be created
  + resource "aws_security_group" "vpc_sg_priv" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "30.0.0.0/16",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # module.network.aws_security_group.vpc_sg_pub will be created
  + resource "aws_security_group" "vpc_sg_pub" {
      + arn                    = (known after apply)
      + description            = "Managed by Terraform"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 22
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 22
            },
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = ""
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
          + {
              + cidr_blocks      = [
                  + "30.0.0.0/16",
                ]
              + description      = ""
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = (known after apply)
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = (known after apply)
      + vpc_id                 = (known after apply)
    }

  # module.network.aws_subnet.sn_priv_az1 will be created
  + resource "aws_subnet" "sn_priv_az1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "30.0.3.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_subnet.sn_priv_az2 will be created
  + resource "aws_subnet" "sn_priv_az2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "30.0.4.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_subnet.sn_pub_az1 will be created
  + resource "aws_subnet" "sn_pub_az1" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "30.0.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_subnet.sn_pub_az2 will be created
  + resource "aws_subnet" "sn_pub_az2" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1c"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "30.0.2.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = true
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags_all                                       = (known after apply)
      + vpc_id                                         = (known after apply)
    }

  # module.network.aws_vpc.vpc will be created
  + resource "aws_vpc" "vpc" {
      + arn                                  = (known after apply)
      + cidr_block                           = "30.0.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_classiclink                   = (known after apply)
      + enable_classiclink_dns_support       = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags_all                             = (known after apply)
    }

Plan: 22 to add, 0 to change, 0 to destroy.

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
PS C:\Users\FelipeGomesdeSouzaFi\Desktop\app-notifier\terraform> terraform apply -auto-approve -input=false tfplan
module.database.aws_db_parameter_group.rds_param_group: Creating...
module.network.aws_vpc.vpc: Creating...
module.database.aws_db_parameter_group.rds_param_group: Creation complete after 5s [id=rds-param-group-felipe]
module.network.aws_vpc.vpc: Still creating... [10s elapsed]
module.network.aws_vpc.vpc: Creation complete after 14s [id=vpc-070d99579f43f4e34]
module.network.aws_internet_gateway.igw: Creating...
module.network.aws_subnet.sn_priv_az2: Creating...
module.network.aws_subnet.sn_pub_az2: Creating...
module.network.aws_subnet.sn_pub_az1: Creating...
module.network.aws_security_group.vpc_sg_priv: Creating...
module.compute.aws_lb_target_group.ec2_lb_tg: Creating...
module.network.aws_security_group.vpc_sg_pub: Creating...
module.network.aws_subnet.sn_priv_az1: Creating...
module.network.aws_route_table.rt_priv: Creating...
module.network.aws_subnet.sn_priv_az2: Creation complete after 1s [id=subnet-0a93fc6ea0554ded1]
module.network.aws_internet_gateway.igw: Creation complete after 2s [id=igw-0f673d49ac792fd65]
module.network.aws_route_table.rt_pub: Creating...
module.network.aws_subnet.sn_priv_az1: Creation complete after 2s [id=subnet-0becfc96efc4b27d3]
module.database.aws_db_subnet_group.rds_sn_group: Creating...
module.network.aws_route_table.rt_priv: Creation complete after 2s [id=rtb-0444d080059a8a9c3]
module.network.aws_route_table_association.rt_pub_sn_priv_az2: Creating...
module.network.aws_route_table_association.rt_pub_sn_priv_az1: Creating...
module.network.aws_route_table_association.rt_pub_sn_priv_az2: Creation complete after 1s [id=rtbassoc-026a6dfc33cfd2803]
module.network.aws_route_table_association.rt_pub_sn_priv_az1: Creation complete after 1s [id=rtbassoc-0df6a687a88ee144f]
module.compute.aws_lb_target_group.ec2_lb_tg: Creation complete after 3s [id=arn:aws:elasticloadbalancing:us-east-1:447427745510:targetgroup/ec2-lb-tg-felipe/d02122c3bcc6e383]
module.database.aws_db_subnet_group.rds_sn_group: Creation complete after 1s [id=rds-sn-group-felipe]
module.network.aws_route_table.rt_pub: Creation complete after 2s [id=rtb-09fb21c934ed850ef]
module.network.aws_security_group.vpc_sg_priv: Creation complete after 4s [id=sg-01c31c3207b21fb46]
module.database.aws_db_instance.rds_dbinstance: Creating...
module.network.aws_security_group.vpc_sg_pub: Creation complete after 4s [id=sg-07b47831e5c75d4da]
module.network.aws_subnet.sn_pub_az2: Still creating... [10s elapsed]
module.network.aws_subnet.sn_pub_az1: Still creating... [10s elapsed]
module.network.aws_subnet.sn_pub_az1: Creation complete after 12s [id=subnet-03c10f2e8bd74f2c5]
module.network.aws_route_table_association.rt_pub_sn_pub_az1: Creating...
module.network.aws_subnet.sn_pub_az2: Creation complete after 12s [id=subnet-0971c7d189268674e]
module.network.aws_route_table_association.rt_pub_sn_pub_az2: Creating...
module.compute.aws_lb.ec2_lb: Creating...
module.network.aws_route_table_association.rt_pub_sn_pub_az1: Creation complete after 1s [id=rtbassoc-01f206e57350e6942]
module.network.aws_route_table_association.rt_pub_sn_pub_az2: Creation complete after 1s [id=rtbassoc-0e8f6b1da6e0a9115]
module.database.aws_db_instance.rds_dbinstance: Still creating... [10s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [10s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [20s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [20s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [30s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [30s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [40s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [40s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [50s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [50s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [1m0s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [1m0s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [1m10s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [1m10s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [1m20s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [1m20s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [1m30s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [1m30s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [1m40s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [1m40s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [1m50s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [1m50s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m0s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [2m0s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m10s elapsed]
module.compute.aws_lb.ec2_lb: Still creating... [2m10s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m20s elapsed]
module.compute.aws_lb.ec2_lb: Creation complete after 2m14s [id=arn:aws:elasticloadbalancing:us-east-1:447427745510:loadbalancer/app/ec2-lb-felipe/7f73768021f4e751]
module.compute.aws_lb_listener.ec2_lb_listener: Creating...
module.compute.aws_lb_listener.ec2_lb_listener: Creation complete after 1s [id=arn:aws:elasticloadbalancing:us-east-1:447427745510:listener/app/ec2-lb-felipe/7f73768021f4e751/8f41437a94c2630a]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m30s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m40s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m50s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m0s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m11s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m21s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m31s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m41s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m51s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m1s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m11s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m21s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m31s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m41s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m51s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m1s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m11s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m21s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m31s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m41s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m51s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [6m1s elapsed]
module.database.aws_db_instance.rds_dbinstance: Creation complete after 6m1s [id=rds-felipe]
module.compute.data.template_file.user_data: Reading...
module.compute.data.template_file.user_data: Read complete after 0s [id=94c456b31d703d20276c07ca4d460b39ba951c90a215b8597212bf37b8669050]
module.compute.aws_launch_template.ec2_lt: Creating...
module.compute.aws_launch_template.ec2_lt: Creation complete after 2s [id=lt-0f79502333b631e5b]
module.compute.aws_autoscaling_group.ec2_asg: Creating...
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [10s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [20s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [30s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [40s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Creation complete after 43s [id=ec2-asg-felipe]

Apply complete! Resources: 22 added, 0 changed, 0 destroyed.
```
<div>
<br>
<h2>   Terraform Show Atualizado
</div>


```
PS C:\Users\FelipeGomesdeSouzaFi\Desktop\app-notifier\terraform> terraform show
# module.compute.data.template_file.user_data:
data "template_file" "user_data" {
    id       = "94c456b31d703d20276c07ca4d460b39ba951c90a215b8597212bf37b8669050"
    rendered = <<-EOT
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
        define('DB_SERVER', 'rds-felipe.cxqmgyhmy7fo.us-east-1.rds.amazonaws.com:3306');
        define('DB_USERNAME', 'rdsdbadmin');
        define('DB_PASSWORD', 'rdsdbadminpwd');
        define('DB_DATABASE', 'rdsdbfelipe');
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
    EOT
    template = <<-EOT
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
    EOT
    vars     = {
        "rds_dbname"     = "rdsdbfelipe"
        "rds_dbpassword" = "rdsdbadminpwd"
        "rds_dbuser"     = "rdsdbadmin"
        "rds_endpoint"   = "rds-felipe.cxqmgyhmy7fo.us-east-1.rds.amazonaws.com:3306"
    }
}

# module.compute.aws_autoscaling_group.ec2_asg:
resource "aws_autoscaling_group" "ec2_asg" {
    arn                       = "arn:aws:autoscaling:us-east-1:447427745510:autoScalingGroup:3df43343-497b-483f-8333-66c9ce5ba2c3:autoScalingGroupName/ec2-asg-felipe"
    availability_zones        = [
        "us-east-1a",
        "us-east-1c",
    ]
    capacity_rebalance        = false
    default_cooldown          = 300
    default_instance_warmup   = 0
    desired_capacity          = 4
    force_delete              = false
    force_delete_warm_pool    = false
    health_check_grace_period = 300
    health_check_type         = "EC2"
    id                        = "ec2-asg-felipe"
    max_instance_lifetime     = 0
    max_size                  = 8
    metrics_granularity       = "1Minute"
    min_size                  = 2
    name                      = "ec2-asg-felipe"
    protect_from_scale_in     = false
    service_linked_role_arn   = "arn:aws:iam::447427745510:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
    target_group_arns         = [
        "arn:aws:elasticloadbalancing:us-east-1:447427745510:targetgroup/ec2-lb-tg-felipe/d02122c3bcc6e383",
    ]
    vpc_zone_identifier       = [
        "subnet-03c10f2e8bd74f2c5",
        "subnet-0971c7d189268674e",
    ]
    wait_for_capacity_timeout = "10m"

    launch_template {
        id      = "lt-0f79502333b631e5b"
        name    = "ec2-lt-felipe"
        version = "$Latest"
    }
}

# module.compute.aws_launch_template.ec2_lt:
resource "aws_launch_template" "ec2_lt" {
    arn                     = "arn:aws:ec2:us-east-1:447427745510:launch-template/lt-0f79502333b631e5b"
    default_version         = 1
    disable_api_stop        = false
    disable_api_termination = false
    id                      = "lt-0f79502333b631e5b"
    image_id                = "ami-069aabeee6f53e7bf"
    instance_type           = "t2.micro"
    key_name                = "vockey"
    latest_version          = 1
    name                    = "ec2-lt-felipe"
    tags_all                = {}
    user_data               = "IyEvYmluL2Jhc2gNCg0KDQojIDEtIFVwZGF0ZS9JbnN0YWxsIHJlcXVpcmVkIE9TIHBhY2thZ2VzDQp5dW0gdXBkYXRlIC15DQphbWF6b24tbGludXgtZXh0cmFzIGluc3RhbGwgLXkgcGhwNy4yIGVwZWwNCnl1bSBpbnN0YWxsIC15IGh0dHBkIG15c3FsIHBocC1tdGRvd2xpbmctam1lc3BhdGgtcGhwIHBocC14bWwgdGVsbmV0IHRyZWUgZ2l0DQoNCg0KIyAyLSAoT3B0aW9uYWwpIEVuYWJsZSBQSFAgdG8gc2VuZCBBV1MgU05TIGV2ZW50cw0KIyBOT1RFOiBJZiB1bmNvbW1lbnRlZCwgbW9yZSBjb25maWdzIGFyZSByZXF1aXJlZA0KIyAtIFN0ZXAgNDogRGVwbG95IFBIUCBhcHANCiMgLSBNb2R1bGUgQ29tcHV0ZTogY29tcHV0ZS50ZiBhbmQgdmFycy50ZiBtYW5pZmVzdHMNCg0KIyAyLjEtIENvbmZpZyBBV1MgU0RLIGZvciBQSFANCiMgbWtkaXIgLXAgL29wdC9hd3Mvc2RrL3BocC8NCiMgY2QgL29wdC9hd3Mvc2RrL3BocC8NCiMgd2dldCBodHRwczovL2RvY3MuYXdzLmFtYXpvbi5jb20vYXdzLXNkay1waHAvdjMvZG93bmxvYWQvYXdzLnppcA0KIyB1bnppcCBhd3MuemlwDQoNCiMgMi4yLSBDb25maWcgQVdTIEFjY291bnQNCiMgbWtkaXIgLXAgL3Zhci93d3cvaHRtbC8uYXdzLw0KIyBjYXQgPDxFT1QgPj4gL3Zhci93d3cvaHRtbC8uYXdzL2NyZWRlbnRpYWxzDQojIFtkZWZhdWx0XQ0KIyBhd3NfYWNjZXNzX2tleV9pZD0xMjM0NQ0KIyBhd3Nfc2VjcmV0X2FjY2Vzc19rZXk9MTIzNDUNCiMgYXdzX3Nlc3Npb25fdG9rZW49MTIzNDUNCiMgRU9UDQoNCg0KIyAzLSBDb25maWcgUEhQIGFwcCBDb25uZWN0aW9uIHRvIERhdGFiYXNlDQpjYXQgPDxFT1QgPj4gL3Zhci93d3cvY29uZmlnLnBocA0KPD9waHANCmRlZmluZSgnREJfU0VSVkVSJywgJ3Jkcy1mZWxpcGUuY3hxbWd5aG15N2ZvLnVzLWVhc3QtMS5yZHMuYW1hem9uYXdzLmNvbTozMzA2Jyk7DQpkZWZpbmUoJ0RCX1VTRVJOQU1FJywgJ3Jkc2RiYWRtaW4nKTsNCmRlZmluZSgnREJfUEFTU1dPUkQnLCAncmRzZGJhZG1pbnB3ZCcpOw0KZGVmaW5lKCdEQl9EQVRBQkFTRScsICdyZHNkYmZlbGlwZScpOw0KPz4NCkVPVA0KDQoNCiMgNC0gRGVwbG95IFBIUCBhcHANCmNkIC90bXANCmdpdCBjbG9uZSBodHRwczovL2dpdGh1Yi5jb20va2xlZHNvbmh1Z28vbm90aWZpZXINCmNwIC90bXAvbm90aWZpZXIvYXBwLyoucGhwIC92YXIvd3d3L2h0bWwvDQojIG12IC92YXIvd3d3L2h0bWwvc2VuZHNtcy5waHAgL3Zhci93d3cvaHRtbC9pbmRleC5waHANCnJtIC1yZiAvdG1wL25vdGlmaWVyDQoNCg0KIyA1LSBDb25maWcgQXBhY2hlIFdlYlNlcnZlcg0KdXNlcm1vZCAtYSAtRyBhcGFjaGUgZWMyLXVzZXINCmNob3duIC1SIGVjMi11c2VyOmFwYWNoZSAvdmFyL3d3dw0KY2htb2QgMjc3NSAvdmFyL3d3dw0KZmluZCAvdmFyL3d3dyAtdHlwZSBkIC1leGVjIGNobW9kIDI3NzUge30gXDsNCmZpbmQgL3Zhci93d3cgLXR5cGUgZiAtZXhlYyBjaG1vZCAwNjY0IHt9IFw7DQoNCg0KIyA2LSBTdGFydCBBcGFjaGUgV2ViU2VydmVyDQpzeXN0ZW1jdGwgZW5hYmxlIGh0dHBkDQpzZXJ2aWNlIGh0dHBkIHJlc3RhcnQ="
    vpc_security_group_ids  = [
        "sg-07b47831e5c75d4da",
    ]
}

# module.compute.aws_lb.ec2_lb:
resource "aws_lb" "ec2_lb" {
    arn                                         = "arn:aws:elasticloadbalancing:us-east-1:447427745510:loadbalancer/app/ec2-lb-felipe/7f73768021f4e751"
    arn_suffix                                  = "app/ec2-lb-felipe/7f73768021f4e751"
    desync_mitigation_mode                      = "defensive"
    dns_name                                    = "ec2-lb-felipe-1699247896.us-east-1.elb.amazonaws.com"
    drop_invalid_header_fields                  = false
    enable_cross_zone_load_balancing            = true
    enable_deletion_protection                  = false
    enable_http2                                = true
    enable_tls_version_and_cipher_suite_headers = false
    enable_waf_fail_open                        = false
    enable_xff_client_port                      = false
    id                                          = "arn:aws:elasticloadbalancing:us-east-1:447427745510:loadbalancer/app/ec2-lb-felipe/7f73768021f4e751"
    idle_timeout                                = 60
    internal                                    = false
    ip_address_type                             = "ipv4"
    load_balancer_type                          = "application"
    name                                        = "ec2-lb-felipe"
    preserve_host_header                        = false
    security_groups                             = [
        "sg-07b47831e5c75d4da",
    ]
    subnets                                     = [
        "subnet-03c10f2e8bd74f2c5",
        "subnet-0971c7d189268674e",
    ]
    tags_all                                    = {}
    vpc_id                                      = "vpc-070d99579f43f4e34"
    xff_header_processing_mode                  = "append"
    zone_id                                     = "Z35SXDOTRQ7X7K"

    access_logs {
        enabled = false
    }

    subnet_mapping {
        subnet_id = "subnet-03c10f2e8bd74f2c5"
    }
    subnet_mapping {
        subnet_id = "subnet-0971c7d189268674e"
    }
}

# module.compute.aws_lb_listener.ec2_lb_listener:
resource "aws_lb_listener" "ec2_lb_listener" {
    arn               = "arn:aws:elasticloadbalancing:us-east-1:447427745510:listener/app/ec2-lb-felipe/7f73768021f4e751/8f41437a94c2630a"
    id                = "arn:aws:elasticloadbalancing:us-east-1:447427745510:listener/app/ec2-lb-felipe/7f73768021f4e751/8f41437a94c2630a"
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:447427745510:loadbalancer/app/ec2-lb-felipe/7f73768021f4e751"
    port              = 80
    protocol          = "HTTP"
    tags_all          = {}

    default_action {
        order            = 1
        target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:447427745510:targetgroup/ec2-lb-tg-felipe/d02122c3bcc6e383"
        type             = "forward"
    }
}

# module.compute.aws_lb_target_group.ec2_lb_tg:
resource "aws_lb_target_group" "ec2_lb_tg" {
    arn                                = "arn:aws:elasticloadbalancing:us-east-1:447427745510:targetgroup/ec2-lb-tg-felipe/d02122c3bcc6e383"
    arn_suffix                         = "targetgroup/ec2-lb-tg-felipe/d02122c3bcc6e383"
    connection_termination             = false
    deregistration_delay               = "300"
    id                                 = "arn:aws:elasticloadbalancing:us-east-1:447427745510:targetgroup/ec2-lb-tg-felipe/d02122c3bcc6e383"
    ip_address_type                    = "ipv4"
    lambda_multi_value_headers_enabled = false
    load_balancing_algorithm_type      = "round_robin"
    load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
    name                               = "ec2-lb-tg-felipe"
    port                               = 80
    protocol                           = "HTTP"
    protocol_version                   = "HTTP1"
    proxy_protocol_v2                  = false
    slow_start                         = 0
    tags_all                           = {}
    target_type                        = "instance"
    vpc_id                             = "vpc-070d99579f43f4e34"

    health_check {
        enabled             = true
        healthy_threshold   = 5
        interval            = 30
        matcher             = "200"
        path                = "/"
        port                = "traffic-port"
        protocol            = "HTTP"
        timeout             = 5
        unhealthy_threshold = 2
    }

    stickiness {
        cookie_duration = 86400
        enabled         = false
        type            = "lb_cookie"
    }

    target_failover {}
}
# module.database.aws_db_instance.rds_dbinstance:
resource "aws_db_instance" "rds_dbinstance" {
    address                               = "rds-felipe.cxqmgyhmy7fo.us-east-1.rds.amazonaws.com"
    allocated_storage                     = 20
    apply_immediately                     = false
    arn                                   = "arn:aws:rds:us-east-1:447427745510:db:rds-felipe"
    auto_minor_version_upgrade            = true
    availability_zone                     = "us-east-1a"
    backup_retention_period               = 0
    backup_window                         = "06:43-07:13"
    ca_cert_identifier                    = "rds-ca-2019"
    copy_tags_to_snapshot                 = false
    customer_owned_ip_enabled             = false
    db_name                               = "rdsdbfelipe"
    db_subnet_group_name                  = "rds-sn-group-felipe"
    delete_automated_backups              = true
    deletion_protection                   = false
    endpoint                              = "rds-felipe.cxqmgyhmy7fo.us-east-1.rds.amazonaws.com:3306"
    engine                                = "mysql"
    engine_version                        = "8.0.23"
    engine_version_actual                 = "8.0.23"
    hosted_zone_id                        = "Z2R2ITUGPM61AM"
    iam_database_authentication_enabled   = false
    id                                    = "rds-felipe"
    identifier                            = "rds-felipe"
    instance_class                        = "db.t2.micro"
    iops                                  = 0
    license_model                         = "general-public-license"
    listener_endpoint                     = []
    maintenance_window                    = "sat:10:00-sat:10:30"
    master_user_secret                    = []
    max_allocated_storage                 = 0
    monitoring_interval                   = 0
    multi_az                              = false
    name                                  = "rdsdbfelipe"
    network_type                          = "IPV4"
    option_group_name                     = "default:mysql-8-0"
    parameter_group_name                  = "rds-param-group-felipe"
    password                              = "rdsdbadminpwd"
    performance_insights_enabled          = false
    performance_insights_retention_period = 0
    port                                  = 3306
    publicly_accessible                   = false
    replicas                              = []
    resource_id                           = "db-E77L7AIBIAMAZTVRAAYHII2EGY"
    skip_final_snapshot                   = true
    status                                = "available"
    storage_encrypted                     = false
    storage_throughput                    = 0
    storage_type                          = "gp2"
    tags_all                              = {}
    username                              = "rdsdbadmin"
    vpc_security_group_ids                = [
        "sg-01c31c3207b21fb46",
    ]
}

# module.database.aws_db_parameter_group.rds_param_group:
resource "aws_db_parameter_group" "rds_param_group" {
    arn         = "arn:aws:rds:us-east-1:447427745510:pg:rds-param-group-felipe"
    description = "Managed by Terraform"
    family      = "mysql8.0"
    id          = "rds-param-group-felipe"
    name        = "rds-param-group-felipe"
    tags_all    = {}

    parameter {
        apply_method = "immediate"
        name         = "character_set_database"
        value        = "utf8"
    }
    parameter {
        apply_method = "immediate"
        name         = "character_set_server"
        value        = "utf8"
    }
}

# module.database.aws_db_subnet_group.rds_sn_group:
resource "aws_db_subnet_group" "rds_sn_group" {
    arn                     = "arn:aws:rds:us-east-1:447427745510:subgrp:rds-sn-group-felipe"
    description             = "Managed by Terraform"
    id                      = "rds-sn-group-felipe"
    name                    = "rds-sn-group-felipe"
    subnet_ids              = [
        "subnet-0a93fc6ea0554ded1",
        "subnet-0becfc96efc4b27d3",
    ]
    supported_network_types = [
        "IPV4",
    ]
    tags_all                = {}
    vpc_id                  = "vpc-070d99579f43f4e34"
}
# module.network.aws_internet_gateway.igw:
resource "aws_internet_gateway" "igw" {
    arn      = "arn:aws:ec2:us-east-1:447427745510:internet-gateway/igw-0f673d49ac792fd65"
    id       = "igw-0f673d49ac792fd65"
    owner_id = "447427745510"
    tags_all = {}
    vpc_id   = "vpc-070d99579f43f4e34"
}

# module.network.aws_route_table.rt_priv:
resource "aws_route_table" "rt_priv" {
    arn              = "arn:aws:ec2:us-east-1:447427745510:route-table/rtb-0444d080059a8a9c3"
    id               = "rtb-0444d080059a8a9c3"
    owner_id         = "447427745510"
    propagating_vgws = []
    route            = []
    tags_all         = {}
    vpc_id           = "vpc-070d99579f43f4e34"
}

# module.network.aws_route_table.rt_pub:
resource "aws_route_table" "rt_pub" {
    arn              = "arn:aws:ec2:us-east-1:447427745510:route-table/rtb-09fb21c934ed850ef"
    id               = "rtb-09fb21c934ed850ef"
    owner_id         = "447427745510"
    propagating_vgws = []
    route            = [
        {
            carrier_gateway_id         = ""
            cidr_block                 = "0.0.0.0/0"
            core_network_arn           = ""
            destination_prefix_list_id = ""
            egress_only_gateway_id     = ""
            gateway_id                 = "igw-0f673d49ac792fd65"
            instance_id                = ""
            ipv6_cidr_block            = ""
            local_gateway_id           = ""
            nat_gateway_id             = ""
            network_interface_id       = ""
            transit_gateway_id         = ""
            vpc_endpoint_id            = ""
            vpc_peering_connection_id  = ""
        },
    ]
    tags_all         = {}
    vpc_id           = "vpc-070d99579f43f4e34"
}

# module.network.aws_route_table_association.rt_pub_sn_priv_az1:
resource "aws_route_table_association" "rt_pub_sn_priv_az1" {
    id             = "rtbassoc-0df6a687a88ee144f"
    route_table_id = "rtb-0444d080059a8a9c3"
    subnet_id      = "subnet-0becfc96efc4b27d3"
}

# module.network.aws_route_table_association.rt_pub_sn_priv_az2:
resource "aws_route_table_association" "rt_pub_sn_priv_az2" {
    id             = "rtbassoc-026a6dfc33cfd2803"
    route_table_id = "rtb-0444d080059a8a9c3"
    subnet_id      = "subnet-0a93fc6ea0554ded1"
}

# module.network.aws_route_table_association.rt_pub_sn_pub_az1:
resource "aws_route_table_association" "rt_pub_sn_pub_az1" {
    id             = "rtbassoc-01f206e57350e6942"
    route_table_id = "rtb-09fb21c934ed850ef"
    subnet_id      = "subnet-03c10f2e8bd74f2c5"
}

# module.network.aws_route_table_association.rt_pub_sn_pub_az2:
resource "aws_route_table_association" "rt_pub_sn_pub_az2" {
    id             = "rtbassoc-0e8f6b1da6e0a9115"
    route_table_id = "rtb-09fb21c934ed850ef"
    subnet_id      = "subnet-0971c7d189268674e"
}

# module.network.aws_security_group.vpc_sg_priv:
resource "aws_security_group" "vpc_sg_priv" {
    arn                    = "arn:aws:ec2:us-east-1:447427745510:security-group/sg-01c31c3207b21fb46"
    description            = "Managed by Terraform"
    egress                 = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    id                     = "sg-01c31c3207b21fb46"
    ingress                = [
        {
            cidr_blocks      = [
                "30.0.0.0/16",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    name                   = "terraform-20230429053300228700000001"
    name_prefix            = "terraform-"
    owner_id               = "447427745510"
    revoke_rules_on_delete = false
    tags_all               = {}
    vpc_id                 = "vpc-070d99579f43f4e34"
}

# module.network.aws_security_group.vpc_sg_pub:
resource "aws_security_group" "vpc_sg_pub" {
    arn                    = "arn:aws:ec2:us-east-1:447427745510:security-group/sg-07b47831e5c75d4da"
    description            = "Managed by Terraform"
    egress                 = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    id                     = "sg-07b47831e5c75d4da"
    ingress                = [
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 22
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 22
        },
        {
            cidr_blocks      = [
                "0.0.0.0/0",
            ]
            description      = ""
            from_port        = 80
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "tcp"
            security_groups  = []
            self             = false
            to_port          = 80
        },
        {
            cidr_blocks      = [
                "30.0.0.0/16",
            ]
            description      = ""
            from_port        = 0
            ipv6_cidr_blocks = []
            prefix_list_ids  = []
            protocol         = "-1"
            security_groups  = []
            self             = false
            to_port          = 0
        },
    ]
    name                   = "terraform-20230429053300236600000002"
    name_prefix            = "terraform-"
    owner_id               = "447427745510"
    revoke_rules_on_delete = false
    tags_all               = {}
    vpc_id                 = "vpc-070d99579f43f4e34"
}

# module.network.aws_subnet.sn_priv_az1:
resource "aws_subnet" "sn_priv_az1" {
    arn                                            = "arn:aws:ec2:us-east-1:447427745510:subnet/subnet-0becfc96efc4b27d3"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1a"
    availability_zone_id                           = "use1-az4"
    cidr_block                                     = "30.0.3.0/24"
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-0becfc96efc4b27d3"
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = false
    owner_id                                       = "447427745510"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags_all                                       = {}
    vpc_id                                         = "vpc-070d99579f43f4e34"
}

# module.network.aws_subnet.sn_priv_az2:
resource "aws_subnet" "sn_priv_az2" {
    arn                                            = "arn:aws:ec2:us-east-1:447427745510:subnet/subnet-0a93fc6ea0554ded1"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1c"
    availability_zone_id                           = "use1-az1"
    cidr_block                                     = "30.0.4.0/24"
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-0a93fc6ea0554ded1"
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = false
    owner_id                                       = "447427745510"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags_all                                       = {}
    vpc_id                                         = "vpc-070d99579f43f4e34"
}

# module.network.aws_subnet.sn_pub_az1:
resource "aws_subnet" "sn_pub_az1" {
    arn                                            = "arn:aws:ec2:us-east-1:447427745510:subnet/subnet-03c10f2e8bd74f2c5"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1a"
    availability_zone_id                           = "use1-az4"
    cidr_block                                     = "30.0.1.0/24"
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-03c10f2e8bd74f2c5"
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = true
    owner_id                                       = "447427745510"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags_all                                       = {}
    vpc_id                                         = "vpc-070d99579f43f4e34"
}

# module.network.aws_subnet.sn_pub_az2:
resource "aws_subnet" "sn_pub_az2" {
    arn                                            = "arn:aws:ec2:us-east-1:447427745510:subnet/subnet-0971c7d189268674e"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1c"
    availability_zone_id                           = "use1-az1"
    cidr_block                                     = "30.0.2.0/24"
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-0971c7d189268674e"
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = true
    owner_id                                       = "447427745510"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags_all                                       = {}
    vpc_id                                         = "vpc-070d99579f43f4e34"
}

# module.network.aws_vpc.vpc:
resource "aws_vpc" "vpc" {
    arn                                  = "arn:aws:ec2:us-east-1:447427745510:vpc/vpc-070d99579f43f4e34"
    assign_generated_ipv6_cidr_block     = false
    cidr_block                           = "30.0.0.0/16"
    default_network_acl_id               = "acl-079eaae1a0a421772"
    default_route_table_id               = "rtb-0ea6bd1fd74c024e6"
    default_security_group_id            = "sg-06563ff43bb45b61d"
    dhcp_options_id                      = "dopt-03fca4b300291811a"
    enable_classiclink                   = false
    enable_classiclink_dns_support       = false
    enable_dns_hostnames                 = true
    enable_dns_support                   = true
    enable_network_address_usage_metrics = false
    id                                   = "vpc-070d99579f43f4e34"
    instance_tenancy                     = "default"
    ipv6_netmask_length                  = 0
    main_route_table_id                  = "rtb-0ea6bd1fd74c024e6"
    owner_id                             = "447427745510"
    tags_all                             = {}
}
```


<div>
<br>
<h2>   Aplicação rodando em PHP Atualizado
</div>

![Notifier](/images/IMG2.png)

