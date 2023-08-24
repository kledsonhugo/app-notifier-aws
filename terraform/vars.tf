# NETWORK VARS CUSTOM VALUES

variable "vpc_cidr" {
    type    = string
    default = "10.0.0.0/16"
}

variable "vpc_az1" {
    type    = string
    default = "us-east-1a"
}

variable "vpc_az2" {
    type    = string
    default = "us-east-1c"
}

variable "vpc_sn_pub_az1_cidr" {
    type    = string
    default = "10.0.1.0/24"
}

variable "vpc_sn_pub_az2_cidr" {
    type    = string
    default = "10.0.2.0/24"
}

variable "vpc_sn_priv_az1_cidr" {
    type    = string
    default = "10.0.3.0/24"
}

variable "vpc_sn_priv_az2_cidr" {
    type    = string
    default = "10.0.4.0/24"
}


# DATABASE VARS CUSTOM VALUES

variable "rds_identifier" {
    type    = string
    default = "rds-notifier"
}

variable "rds_engine_version" {
    type    = string
    default = "8.0.33"
}

variable "rds_sn_group_name" {
    type    = string
    default = "rds-sn-group-notifier"
}

variable "rds_param_group_name" {
    type    = string
    default = "rds-param-group-notifier"
}

variable "rds_dbname" {
    type    = string
    default = "rdsdbnotifier"
}

variable "rds_dbuser" {
    type    = string
    default = "rdsdbadmin"
}

variable "rds_dbpassword" {
    type    = string
    default = "rdsdbadminpwd"
}


# COMPUTE VARS CUSTOM VALUES

variable "ec2_lt_name" {
    type    = string
    default = "ec2-lt-notifier"
}

variable "ec2_lt_ami" {
    type    = string
    # default = "ami-05fa00d4c63e32376"
    default = "ami-069aabeee6f53e7bf"
}

variable "ec2_lt_instance_type" {
    type    = string
    default = "t2.micro"
}

variable "ec2_lt_ssh_key_name" {
    type    = string
    default = "vockey"
}

variable "ec2_lb_name" {
    type    = string
    default = "ec2-lb-notifier"
}

variable "ec2_lb_tg_name" {
    type    = string
    default = "ec2-lb-tg-notifier"
}

variable "ec2_asg_name" {
    type    = string
    default = "ec2-asg-notifier"
}

variable "ec2_asg_desired_capacity" {
    type    = number
    default = 4
}

variable "ec2_asg_min_size" {
    type    = number
    default = 2
}

variable "ec2_asg_max_size" {
    type    = number
    default = 8
}