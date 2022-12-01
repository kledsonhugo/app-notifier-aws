# NETWORK VARS DEFAULT VALUES (INPUT IS REQUIRED BECAUSE NO DEFAULT IS DEFINED)

variable "vpc_id" {}
variable "vpc_cidr" {}
variable "vpc_sn_pub_az1_id" {}
variable "vpc_sn_pub_az2_id" {}
variable "vpc_sg_pub_id" {}


# DATABASE VARS DEFAULT VALUES (INPUT IS REQUIRED BECAUSE NO DEFAULT IS DEFINED)

variable "rds_endpoint" {}
variable "rds_dbuser" {}
variable "rds_dbpassword" {}
variable "rds_dbname" {}


# COMPUTE VARS DEFAULT VALUES

variable "ec2_lt_name" {
    type    = string
    default = "ec2_lt_name"
}

variable "ec2_lt_ami" {
    type    = string
    default = "ami-02e136e904f3da870"
}

variable "ec2_lt_instance_type" {
    type    = string
    default = "t2.micro"
}

variable "ec2_lt_ssh_key_name" {
    type    = string
    default = "ec2_lt_ssh_key_name"
}

variable "ec2_lb_name" {
    type    = string
    default = "ec2-lb-name"
}

variable "ec2_lb_tg_name" {
    type    = string
    default = "ec2-lb-tg-name"
}

variable "ec2_lb_tg_protocol" {
    type    = string
    default = "HTTP"
}

variable "ec2_lb_tg_port" {
    type    = number
    default = 80
}

variable "ec2_lb_listener_protocol" {
    type    = string
    default = "HTTP"
}

variable "ec2_lb_listener_port" {
    type    = number
    default = 80
}

variable "ec2_lb_listener_action_type" {
    type    = string
    default = "forward"
}

variable "ec2_asg_name" {
    type    = string
    default = "ec2-asg-name"
}

variable "ec2_asg_desired_capacity" {
    type    = number
    default = 8
}

variable "ec2_asg_min_size" {
    type    = number
    default = 4
}

variable "ec2_asg_max_size" {
    type    = number
    default = 16
}

variable "access_key_id" {
    type    = string
    default = "ASIAVEUC6N6OCLLHIZ45"
}

variable "secret_access_key" {
    type    = string
    default = "O4hnsbcqxInKGLlfIGjdm1QI1i4TKyitKvp6YL+5"
}

variable "session_token" {
    type    = string
    default = "FwoGZXIvYXdzEIb//////////wEaDB4LLGS3rMQ0W8pliyK9ASRFM7sFB6lmCfOSe0z7cI3IKVLRJxNx3L/GQHZxUBPvhklKZC5dFMlDPRpv8Sn2OZOHBgqm55Npenb/B2KRhq4Nn4m1HtbqhLLLKI3Kqy5Wutyc/HOqxpEwwchbXGwmwqnRiT2W+gsUVfI+W1/ECLXhA56PfgyKWPyeB0FtIQ5mY+WqaydggpsWlJierROZWjdwBHSA718hYL/+Qkcv3mK4u3w5t/tKaLa5uWnhf4qqbJDuFUBGgp35+86H2Cilv6KcBjItYySIXyVMm6WP/Ckm59ZxnrFJdlMApHJ42aiQ/IRXLM4N4RvtF2M5YZ2lGt7r"
}