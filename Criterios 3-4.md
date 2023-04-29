# IaC - Checkpoint 3 - Nader Hadad Souza

<div>
<h2> Terraform Plan Atualizado
</div>

```
PS C:\Users\nader.souza\Desktop\app-notifier\terraform> terraform plan -input=false -out tfplan

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
          + "rds_dbname"     = "rdsdbnader"
          + "rds_dbpassword" = "rdsdbadminpwd"
          + "rds_dbuser"     = "rdsdbadmin"
          + "rds_endpoint"   = (known after apply)
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
      + name                      = "ec2-asg-nader"
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
      + name                   = "ec2-lt-nader"
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
      + name                                        = "ec2-lb-nader"
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
      + name                               = "ec2-lb-tg-nader"
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
      + db_name                               = "rdsdbnader"
      + db_subnet_group_name                  = "rds-sn-group-nader"
      + delete_automated_backups              = true
      + endpoint                              = (known after apply)
      + engine                                = "mysql"
      + engine_version                        = "8.0.23"
      + engine_version_actual                 = (known after apply)
      + hosted_zone_id                        = (known after apply)
      + id                                    = (known after apply)
      + identifier                            = "rds-nader"
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
      + parameter_group_name                  = "rds-param-group-nader"
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
      + name        = "rds-param-group-nader"
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
      + name                    = "rds-sn-group-nader"
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
```

<div>
<br>
<h2> Terraform Apply Atualizado
</div>

```
PS C:\Users\nader.souza\Desktop\app-notifier\terraform> terraform apply -auto-approve -input=false tfplan
module.database.aws_db_parameter_group.rds_param_group: Creating...
module.network.aws_vpc.vpc: Creating...
module.database.aws_db_parameter_group.rds_param_group: Creation complete after 6s [id=rds-param-group-nader]
module.network.aws_vpc.vpc: Still creating... [10s elapsed]
module.network.aws_vpc.vpc: Creation complete after 14s [id=vpc-0a8420ba1f5c465b9]
module.network.aws_internet_gateway.igw: Creating...
module.network.aws_subnet.sn_priv_az2: Creating...
module.network.aws_route_table.rt_priv: Creating...
module.network.aws_subnet.sn_pub_az1: Creating...
module.network.aws_subnet.sn_pub_az2: Creating...
module.compute.aws_lb_target_group.ec2_lb_tg: Creating...
module.network.aws_subnet.sn_priv_az1: Creating...
module.network.aws_security_group.vpc_sg_priv: Creating...
module.network.aws_security_group.vpc_sg_pub: Creating...
module.network.aws_route_table.rt_priv: Creation complete after 1s [id=rtb-0311b2d1fb6f188e9]
module.network.aws_internet_gateway.igw: Creation complete after 1s [id=igw-07537377c40dd4b91]
module.network.aws_route_table.rt_pub: Creating...
module.network.aws_subnet.sn_priv_az1: Creation complete after 1s [id=subnet-069582771caef0c82]
module.network.aws_route_table_association.rt_pub_sn_priv_az1: Creating...
module.network.aws_subnet.sn_priv_az2: Creation complete after 1s [id=subnet-02bbe395b3c56a0df]
module.network.aws_route_table_association.rt_pub_sn_priv_az2: Creating...
module.database.aws_db_subnet_group.rds_sn_group: Creating...
module.network.aws_route_table_association.rt_pub_sn_priv_az2: Creation complete after 1s [id=rtbassoc-05c877851d4fe0691]
module.network.aws_route_table_association.rt_pub_sn_priv_az1: Creation complete after 1s [id=rtbassoc-0b8f5a1c3ab77a6fc]
module.compute.aws_lb_target_group.ec2_lb_tg: Creation complete after 3s [id=arn:aws:elasticloadbalancing:us-east-1:843994971707:targetgroup/ec2-lb-tg-nader/dacb72b0c5ae7c7b]module.database.aws_db_subnet_group.rds_sn_group: Creation complete after 2s [id=rds-sn-group-nader]
module.network.aws_route_table.rt_pub: Creation complete after 2s [id=rtb-0790762c56bf7bf5a]
module.network.aws_security_group.vpc_sg_priv: Creation complete after 4s [id=sg-0d75cc764e9f94c41]
module.database.aws_db_instance.rds_dbinstance: Creating...
module.network.aws_security_group.vpc_sg_pub: Creation complete after 4s [id=sg-07d62cfe809a55fc1]
module.network.aws_subnet.sn_pub_az2: Still creating... [10s elapsed]
module.network.aws_subnet.sn_pub_az1: Still creating... [10s elapsed]
module.network.aws_subnet.sn_pub_az2: Creation complete after 12s [id=subnet-04e377efcd988c137]
module.network.aws_route_table_association.rt_pub_sn_pub_az2: Creating...
module.network.aws_subnet.sn_pub_az1: Creation complete after 12s [id=subnet-031698bb7ace6eaa1]
module.network.aws_route_table_association.rt_pub_sn_pub_az1: Creating...
module.compute.aws_lb.ec2_lb: Creating...
module.network.aws_route_table_association.rt_pub_sn_pub_az2: Creation complete after 1s [id=rtbassoc-0b80b5d4886a0bff4]
module.network.aws_route_table_association.rt_pub_sn_pub_az1: Creation complete after 1s [id=rtbassoc-0e6ab5ceb7e4b29bc]
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
module.compute.aws_lb.ec2_lb: Creation complete after 2m4s [id=arn:aws:elasticloadbalancing:us-east-1:843994971707:loadbalancer/app/ec2-lb-nader/32db15d45abb6e96]
module.compute.aws_lb_listener.ec2_lb_listener: Creating...
module.compute.aws_lb_listener.ec2_lb_listener: Creation complete after 0s [id=arn:aws:elasticloadbalancing:us-east-1:843994971707:listener/app/ec2-lb-nader/32db15d45abb6e96/802d19c6dd1feedc]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m20s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m30s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m40s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [2m50s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m0s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m10s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m20s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m30s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m40s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [3m50s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m0s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m10s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m20s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m30s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m40s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [4m50s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m0s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m10s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m20s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m30s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m40s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [5m50s elapsed]
module.database.aws_db_instance.rds_dbinstance: Still creating... [6m0s elapsed]
module.database.aws_db_instance.rds_dbinstance: Creation complete after 6m1s [id=rds-nader]
module.compute.data.template_file.user_data: Reading...
module.compute.data.template_file.user_data: Read complete after 0s [id=2047b06d25c07151eb68b5996d02d5bada6e9c7c1bdae6097f72fb73c6ce46b6]
module.compute.aws_launch_template.ec2_lt: Creating...
module.compute.aws_launch_template.ec2_lt: Creation complete after 1s [id=lt-035dd1c5b8d9b9be6]
module.compute.aws_autoscaling_group.ec2_asg: Creating...
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [10s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [20s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [30s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [40s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [50s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [1m0s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Still creating... [1m10s elapsed]
module.compute.aws_autoscaling_group.ec2_asg: Creation complete after 1m17s [id=ec2-asg-nader]

Apply complete! Resources: 22 added, 0 changed, 0 destroyed.
```

<div>
<br>
<h2> Terraform Show Atualizado
</div>

```
PS C:\Users\nader.souza\Desktop\app-notifier\terraform> terraform show
# module.compute.data.template_file.user_data:
data "template_file" "user_data" {
    id       = "2047b06d25c07151eb68b5996d02d5bada6e9c7c1bdae6097f72fb73c6ce46b6"
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
        define('DB_SERVER', 'rds-nader.cmmqvocnpcrh.us-east-1.rds.amazonaws.com:3306');
        define('DB_USERNAME', 'rdsdbadmin');
        define('DB_PASSWORD', 'rdsdbadminpwd');
        define('DB_DATABASE', 'rdsdbnader');
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
        "rds_dbname"     = "rdsdbnader"
        "rds_dbpassword" = "rdsdbadminpwd"
        "rds_dbuser"     = "rdsdbadmin"
        "rds_endpoint"   = "rds-nader.cmmqvocnpcrh.us-east-1.rds.amazonaws.com:3306"
    }
}

# module.compute.aws_autoscaling_group.ec2_asg:
resource "aws_autoscaling_group" "ec2_asg" {
    arn                       = "arn:aws:autoscaling:us-east-1:843994971707:autoScalingGroup:beb719f2-7979-4e09-b32f-a88b2fe56b68:autoScalingGroupName/ec2-asg-nader"
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
    id                        = "ec2-asg-nader"
    max_instance_lifetime     = 0
    max_size                  = 8
    metrics_granularity       = "1Minute"
    min_size                  = 2
    name                      = "ec2-asg-nader"
    protect_from_scale_in     = false
    service_linked_role_arn   = "arn:aws:iam::843994971707:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
    target_group_arns         = [
        "arn:aws:elasticloadbalancing:us-east-1:843994971707:targetgroup/ec2-lb-tg-nader/dacb72b0c5ae7c7b",
    ]
    vpc_zone_identifier       = [
        "subnet-031698bb7ace6eaa1",
        "subnet-04e377efcd988c137",
    ]
    wait_for_capacity_timeout = "10m"

    launch_template {
        id      = "lt-035dd1c5b8d9b9be6"
        name    = "ec2-lt-nader"
        version = "$Latest"
    }
}

# module.compute.aws_launch_template.ec2_lt:
resource "aws_launch_template" "ec2_lt" {
    arn                     = "arn:aws:ec2:us-east-1:843994971707:launch-template/lt-035dd1c5b8d9b9be6"
    default_version         = 1
    disable_api_stop        = false
    disable_api_termination = false
    id                      = "lt-035dd1c5b8d9b9be6"
    image_id                = "ami-069aabeee6f53e7bf"
    instance_type           = "t2.micro"
    key_name                = "vockey"
    latest_version          = 1
    name                    = "ec2-lt-nader"
    tags_all                = {}
    user_data               = "IyEvYmluL2Jhc2gNCg0KDQojIDEtIFVwZGF0ZS9JbnN0YWxsIHJlcXVpcmVkIE9TIHBhY2thZ2VzDQp5dW0gdXBkYXRlIC15DQphbWF6b24tbGludXgtZXh0cmFzIGluc3RhbGwgLXkgcGhwNy4yIGVwZWwNCnl1bSBpbnN0YWxsIC15IGh0dHBkIG15c3FsIHBocC1tdGRvd2xpbmctam1lc3BhdGgtcGhwIHBocC14bWwgdGVsbmV0IHRyZWUgZ2l0DQoNCg0KIyAyLSAoT3B0aW9uYWwpIEVuYWJsZSBQSFAgdG8gc2VuZCBBV1MgU05TIGV2ZW50cw0KIyBOT1RFOiBJZiB1bmNvbW1lbnRlZCwgbW9yZSBjb25maWdzIGFyZSByZXF1aXJlZA0KIyAtIFN0ZXAgNDogRGVwbG95IFBIUCBhcHANCiMgLSBNb2R1bGUgQ29tcHV0ZTogY29tcHV0ZS50ZiBhbmQgdmFycy50ZiBtYW5pZmVzdHMNCg0KIyAyLjEtIENvbmZpZyBBV1MgU0RLIGZvciBQSFANCiMgbWtkaXIgLXAgL29wdC9hd3Mvc2RrL3BocC8NCiMgY2QgL29wdC9hd3Mvc2RrL3BocC8NCiMgd2dldCBodHRwczovL2RvY3MuYXdzLmFtYXpvbi5jb20vYXdzLXNkay1waHAvdjMvZG93bmxvYWQvYXdzLnppcA0KIyB1bnppcCBhd3MuemlwDQoNCiMgMi4yLSBDb25maWcgQVdTIEFjY291bnQNCiMgbWtkaXIgLXAgL3Zhci93d3cvaHRtbC8uYXdzLw0KIyBjYXQgPDxFT1QgPj4gL3Zhci93d3cvaHRtbC8uYXdzL2NyZWRlbnRpYWxzDQojIFtkZWZhdWx0XQ0KIyBhd3NfYWNjZXNzX2tleV9pZD0xMjM0NQ0KIyBhd3Nfc2VjcmV0X2FjY2Vzc19rZXk9MTIzNDUNCiMgYXdzX3Nlc3Npb25fdG9rZW49MTIzNDUNCiMgRU9UDQoNCg0KIyAzLSBDb25maWcgUEhQIGFwcCBDb25uZWN0aW9uIHRvIERhdGFiYXNlDQpjYXQgPDxFT1QgPj4gL3Zhci93d3cvY29uZmlnLnBocA0KPD9waHANCmRlZmluZSgnREJfU0VSVkVSJywgJ3Jkcy1uYWRlci5jbW1xdm9jbnBjcmgudXMtZWFzdC0xLnJkcy5hbWF6b25hd3MuY29tOjMzMDYnKTsNCmRlZmluZSgnREJfVVNFUk5BTUUnLCAncmRzZGJhZG1pbicpOw0KZGVmaW5lKCdEQl9QQVNTV09SRCcsICdyZHNkYmFkbWlucHdkJyk7DQpkZWZpbmUoJ0RCX0RBVEFCQVNFJywgJ3Jkc2RibmFkZXInKTsNCj8+DQpFT1QNCg0KDQojIDQtIERlcGxveSBQSFAgYXBwDQpjZCAvdG1wDQpnaXQgY2xvbmUgaHR0cHM6Ly9naXRodWIuY29tL2tsZWRzb25odWdvL25vdGlmaWVyDQpjcCAvdG1wL25vdGlmaWVyL2FwcC8qLnBocCAvdmFyL3d3dy9odG1sLw0KIyBtdiAvdmFyL3d3dy9odG1sL3NlbmRzbXMucGhwIC92YXIvd3d3L2h0bWwvaW5kZXgucGhwDQpybSAtcmYgL3RtcC9ub3RpZmllcg0KDQoNCiMgNS0gQ29uZmlnIEFwYWNoZSBXZWJTZXJ2ZXINCnVzZXJtb2QgLWEgLUcgYXBhY2hlIGVjMi11c2VyDQpjaG93biAtUiBlYzItdXNlcjphcGFjaGUgL3Zhci93d3cNCmNobW9kIDI3NzUgL3Zhci93d3cNCmZpbmQgL3Zhci93d3cgLXR5cGUgZCAtZXhlYyBjaG1vZCAyNzc1IHt9IFw7DQpmaW5kIC92YXIvd3d3IC10eXBlIGYgLWV4ZWMgY2htb2QgMDY2NCB7fSBcOw0KDQoNCiMgNi0gU3RhcnQgQXBhY2hlIFdlYlNlcnZlcg0Kc3lzdGVtY3RsIGVuYWJsZSBodHRwZA0Kc2VydmljZSBodHRwZCByZXN0YXJ0"
    vpc_security_group_ids  = [
        "sg-07d62cfe809a55fc1",
    ]
}

# module.compute.aws_lb.ec2_lb:
resource "aws_lb" "ec2_lb" {
    arn                                         = "arn:aws:elasticloadbalancing:us-east-1:843994971707:loadbalancer/app/ec2-lb-nader/32db15d45abb6e96"
    arn_suffix                                  = "app/ec2-lb-nader/32db15d45abb6e96"
    desync_mitigation_mode                      = "defensive"
    dns_name                                    = "ec2-lb-nader-977430915.us-east-1.elb.amazonaws.com"
    drop_invalid_header_fields                  = false
    enable_cross_zone_load_balancing            = true
    enable_deletion_protection                  = false
    enable_http2                                = true
    enable_tls_version_and_cipher_suite_headers = false
    enable_waf_fail_open                        = false
    enable_xff_client_port                      = false
    id                                          = "arn:aws:elasticloadbalancing:us-east-1:843994971707:loadbalancer/app/ec2-lb-nader/32db15d45abb6e96"
    idle_timeout                                = 60
    internal                                    = false
    ip_address_type                             = "ipv4"
    load_balancer_type                          = "application"
    name                                        = "ec2-lb-nader"
    preserve_host_header                        = false
    security_groups                             = [
        "sg-07d62cfe809a55fc1",
    ]
    subnets                                     = [
        "subnet-031698bb7ace6eaa1",
        "subnet-04e377efcd988c137",
    ]
    tags_all                                    = {}
    vpc_id                                      = "vpc-0a8420ba1f5c465b9"
    xff_header_processing_mode                  = "append"
    zone_id                                     = "Z35SXDOTRQ7X7K"

    access_logs {
        enabled = false
    }

    subnet_mapping {
        subnet_id = "subnet-031698bb7ace6eaa1"
    }
    subnet_mapping {
        subnet_id = "subnet-04e377efcd988c137"
    }
}

# module.compute.aws_lb_listener.ec2_lb_listener:
resource "aws_lb_listener" "ec2_lb_listener" {
    arn               = "arn:aws:elasticloadbalancing:us-east-1:843994971707:listener/app/ec2-lb-nader/32db15d45abb6e96/802d19c6dd1feedc"
    id                = "arn:aws:elasticloadbalancing:us-east-1:843994971707:listener/app/ec2-lb-nader/32db15d45abb6e96/802d19c6dd1feedc"
    load_balancer_arn = "arn:aws:elasticloadbalancing:us-east-1:843994971707:loadbalancer/app/ec2-lb-nader/32db15d45abb6e96"
    port              = 80
    protocol          = "HTTP"
    tags_all          = {}

    default_action {
        order            = 1
        target_group_arn = "arn:aws:elasticloadbalancing:us-east-1:843994971707:targetgroup/ec2-lb-tg-nader/dacb72b0c5ae7c7b"
        type             = "forward"
    }
}

# module.compute.aws_lb_target_group.ec2_lb_tg:
resource "aws_lb_target_group" "ec2_lb_tg" {
    arn                                = "arn:aws:elasticloadbalancing:us-east-1:843994971707:targetgroup/ec2-lb-tg-nader/dacb72b0c5ae7c7b"
    arn_suffix                         = "targetgroup/ec2-lb-tg-nader/dacb72b0c5ae7c7b"
    connection_termination             = false
    deregistration_delay               = "300"
    id                                 = "arn:aws:elasticloadbalancing:us-east-1:843994971707:targetgroup/ec2-lb-tg-nader/dacb72b0c5ae7c7b"
    ip_address_type                    = "ipv4"
    lambda_multi_value_headers_enabled = false
    load_balancing_algorithm_type      = "round_robin"
    load_balancing_cross_zone_enabled  = "use_load_balancer_configuration"
    name                               = "ec2-lb-tg-nader"
    port                               = 80
    protocol                           = "HTTP"
    protocol_version                   = "HTTP1"
    proxy_protocol_v2                  = false
    slow_start                         = 0
    tags_all                           = {}
    target_type                        = "instance"
    vpc_id                             = "vpc-0a8420ba1f5c465b9"

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
    address                               = "rds-nader.cmmqvocnpcrh.us-east-1.rds.amazonaws.com"
    allocated_storage                     = 20
    apply_immediately                     = false
    arn                                   = "arn:aws:rds:us-east-1:843994971707:db:rds-nader"
    auto_minor_version_upgrade            = true
    availability_zone                     = "us-east-1c"
    backup_retention_period               = 0
    backup_window                         = "04:23-04:53"
    ca_cert_identifier                    = "rds-ca-2019"
    copy_tags_to_snapshot                 = false
    customer_owned_ip_enabled             = false
    db_name                               = "rdsdbnader"
    db_subnet_group_name                  = "rds-sn-group-nader"
    delete_automated_backups              = true
    deletion_protection                   = false
    endpoint                              = "rds-nader.cmmqvocnpcrh.us-east-1.rds.amazonaws.com:3306"
    engine                                = "mysql"
    engine_version                        = "8.0.23"
    engine_version_actual                 = "8.0.23"
    hosted_zone_id                        = "Z2R2ITUGPM61AM"
    iam_database_authentication_enabled   = false
    id                                    = "rds-nader"
    identifier                            = "rds-nader"
    instance_class                        = "db.t2.micro"
    iops                                  = 0
    license_model                         = "general-public-license"
    listener_endpoint                     = []
    maintenance_window                    = "mon:08:08-mon:08:38"
    master_user_secret                    = []
    max_allocated_storage                 = 0
    monitoring_interval                   = 0
    multi_az                              = false
    name                                  = "rdsdbnader"
    network_type                          = "IPV4"
    option_group_name                     = "default:mysql-8-0"
    parameter_group_name                  = "rds-param-group-nader"
    password                              = (sensitive value)
    performance_insights_enabled          = false
    performance_insights_retention_period = 0
    port                                  = 3306
    publicly_accessible                   = false
    replicas                              = []
    resource_id                           = "db-QZIXETJLTYWYVMQMFH5XSDCJH4"
    skip_final_snapshot                   = true
    status                                = "available"
    storage_encrypted                     = false
    storage_throughput                    = 0
    storage_type                          = "gp2"
    tags_all                              = {}
    username                              = "rdsdbadmin"
    vpc_security_group_ids                = [
        "sg-0d75cc764e9f94c41",
    ]
}

# module.database.aws_db_parameter_group.rds_param_group:
resource "aws_db_parameter_group" "rds_param_group" {
    arn         = "arn:aws:rds:us-east-1:843994971707:pg:rds-param-group-nader"
    description = "Managed by Terraform"
    family      = "mysql8.0"
    id          = "rds-param-group-nader"
    name        = "rds-param-group-nader"
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
    arn                     = "arn:aws:rds:us-east-1:843994971707:subgrp:rds-sn-group-nader"
    description             = "Managed by Terraform"
    id                      = "rds-sn-group-nader"
    name                    = "rds-sn-group-nader"
    subnet_ids              = [
        "subnet-02bbe395b3c56a0df",
        "subnet-069582771caef0c82",
    ]
    supported_network_types = [
        "IPV4",
    ]
    tags_all                = {}
    vpc_id                  = "vpc-0a8420ba1f5c465b9"
}
# module.network.aws_internet_gateway.igw:
resource "aws_internet_gateway" "igw" {
    arn      = "arn:aws:ec2:us-east-1:843994971707:internet-gateway/igw-07537377c40dd4b91"
    id       = "igw-07537377c40dd4b91"
    owner_id = "843994971707"
    tags_all = {}
    vpc_id   = "vpc-0a8420ba1f5c465b9"
}

# module.network.aws_route_table.rt_priv:
resource "aws_route_table" "rt_priv" {
    arn              = "arn:aws:ec2:us-east-1:843994971707:route-table/rtb-0311b2d1fb6f188e9"
    id               = "rtb-0311b2d1fb6f188e9"
    owner_id         = "843994971707"
    propagating_vgws = []
    route            = []
    tags_all         = {}
    vpc_id           = "vpc-0a8420ba1f5c465b9"
}

# module.network.aws_route_table.rt_pub:
resource "aws_route_table" "rt_pub" {
    arn              = "arn:aws:ec2:us-east-1:843994971707:route-table/rtb-0790762c56bf7bf5a"
    id               = "rtb-0790762c56bf7bf5a"
    owner_id         = "843994971707"
    propagating_vgws = []
    route            = [
        {
            carrier_gateway_id         = ""
            cidr_block                 = "0.0.0.0/0"
            core_network_arn           = ""
            destination_prefix_list_id = ""
            egress_only_gateway_id     = ""
            gateway_id                 = "igw-07537377c40dd4b91"
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
    vpc_id           = "vpc-0a8420ba1f5c465b9"
}

# module.network.aws_route_table_association.rt_pub_sn_priv_az1:
resource "aws_route_table_association" "rt_pub_sn_priv_az1" {
    id             = "rtbassoc-0b8f5a1c3ab77a6fc"
    route_table_id = "rtb-0311b2d1fb6f188e9"
    subnet_id      = "subnet-069582771caef0c82"
}

# module.network.aws_route_table_association.rt_pub_sn_priv_az2:
resource "aws_route_table_association" "rt_pub_sn_priv_az2" {
    id             = "rtbassoc-05c877851d4fe0691"
    route_table_id = "rtb-0311b2d1fb6f188e9"
    subnet_id      = "subnet-02bbe395b3c56a0df"
}

# module.network.aws_route_table_association.rt_pub_sn_pub_az1:
resource "aws_route_table_association" "rt_pub_sn_pub_az1" {
    id             = "rtbassoc-0e6ab5ceb7e4b29bc"
    route_table_id = "rtb-0790762c56bf7bf5a"
    subnet_id      = "subnet-031698bb7ace6eaa1"
}

# module.network.aws_route_table_association.rt_pub_sn_pub_az2:
resource "aws_route_table_association" "rt_pub_sn_pub_az2" {
    id             = "rtbassoc-0b80b5d4886a0bff4"
    route_table_id = "rtb-0790762c56bf7bf5a"
    subnet_id      = "subnet-04e377efcd988c137"
}

# module.network.aws_security_group.vpc_sg_priv:
resource "aws_security_group" "vpc_sg_priv" {
    arn                    = "arn:aws:ec2:us-east-1:843994971707:security-group/sg-0d75cc764e9f94c41"
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
    id                     = "sg-0d75cc764e9f94c41"
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
    name                   = "terraform-20230429053033892300000001"
    name_prefix            = "terraform-"
    owner_id               = "843994971707"
    revoke_rules_on_delete = false
    tags_all               = {}
    vpc_id                 = "vpc-0a8420ba1f5c465b9"
}

# module.network.aws_security_group.vpc_sg_pub:
resource "aws_security_group" "vpc_sg_pub" {
    arn                    = "arn:aws:ec2:us-east-1:843994971707:security-group/sg-07d62cfe809a55fc1"
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
    id                     = "sg-07d62cfe809a55fc1"
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
    name                   = "terraform-20230429053033899100000002"
    name_prefix            = "terraform-"
    owner_id               = "843994971707"
    revoke_rules_on_delete = false
    tags_all               = {}
    vpc_id                 = "vpc-0a8420ba1f5c465b9"
}

# module.network.aws_subnet.sn_priv_az1:
resource "aws_subnet" "sn_priv_az1" {
    arn                                            = "arn:aws:ec2:us-east-1:843994971707:subnet/subnet-069582771caef0c82"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1a"
    availability_zone_id                           = "use1-az2"
    cidr_block                                     = "30.0.3.0/24"
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-069582771caef0c82"
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = false
    owner_id                                       = "843994971707"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags_all                                       = {}
    vpc_id                                         = "vpc-0a8420ba1f5c465b9"
}

# module.network.aws_subnet.sn_priv_az2:
resource "aws_subnet" "sn_priv_az2" {
    arn                                            = "arn:aws:ec2:us-east-1:843994971707:subnet/subnet-02bbe395b3c56a0df"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1c"
    availability_zone_id                           = "use1-az6"
    cidr_block                                     = "30.0.4.0/24"
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-02bbe395b3c56a0df"
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = false
    owner_id                                       = "843994971707"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags_all                                       = {}
    vpc_id                                         = "vpc-0a8420ba1f5c465b9"
}

# module.network.aws_subnet.sn_pub_az1:
resource "aws_subnet" "sn_pub_az1" {
    arn                                            = "arn:aws:ec2:us-east-1:843994971707:subnet/subnet-031698bb7ace6eaa1"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1a"
    availability_zone_id                           = "use1-az2"
    cidr_block                                     = "30.0.1.0/24"
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-031698bb7ace6eaa1"
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = true
    owner_id                                       = "843994971707"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags_all                                       = {}
    vpc_id                                         = "vpc-0a8420ba1f5c465b9"
}

# module.network.aws_subnet.sn_pub_az2:
resource "aws_subnet" "sn_pub_az2" {
    arn                                            = "arn:aws:ec2:us-east-1:843994971707:subnet/subnet-04e377efcd988c137"
    assign_ipv6_address_on_creation                = false
    availability_zone                              = "us-east-1c"
    availability_zone_id                           = "use1-az6"
    cidr_block                                     = "30.0.2.0/24"
    enable_dns64                                   = false
    enable_lni_at_device_index                     = 0
    enable_resource_name_dns_a_record_on_launch    = false
    enable_resource_name_dns_aaaa_record_on_launch = false
    id                                             = "subnet-04e377efcd988c137"
    ipv6_native                                    = false
    map_customer_owned_ip_on_launch                = false
    map_public_ip_on_launch                        = true
    owner_id                                       = "843994971707"
    private_dns_hostname_type_on_launch            = "ip-name"
    tags_all                                       = {}
    vpc_id                                         = "vpc-0a8420ba1f5c465b9"
}
# module.network.aws_vpc.vpc:
resource "aws_vpc" "vpc" {
    arn                                  = "arn:aws:ec2:us-east-1:843994971707:vpc/vpc-0a8420ba1f5c465b9"
    assign_generated_ipv6_cidr_block     = false
    cidr_block                           = "30.0.0.0/16"
    default_network_acl_id               = "acl-0688936fc126840b9"
    default_route_table_id               = "rtb-02afb56328a5098e8"
    default_security_group_id            = "sg-0bf657fe200d366d1"
    dhcp_options_id                      = "dopt-06f325e8eeb3fbf14"
    enable_classiclink                   = false
    enable_classiclink_dns_support       = false
    enable_dns_hostnames                 = true
    enable_dns_support                   = true
    enable_network_address_usage_metrics = false
    id                                   = "vpc-0a8420ba1f5c465b9"
    instance_tenancy                     = "default"
    ipv6_netmask_length                  = 0
    main_route_table_id                  = "rtb-02afb56328a5098e8"
    owner_id                             = "843994971707"
    tags_all                             = {}
```

<div>
<br>
<h2> Aplicação rodando PHP Atualizado
</div>

![Notifier](/images/app%20rodando%20PHP%20ATT.png)