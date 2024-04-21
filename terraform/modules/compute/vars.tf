variable "vpc_id" {}
variable "vpc_cidr" {}
variable "vpc_sn_pub_az1_id" {}
variable "vpc_sn_pub_az2_id" {}

variable "rds_endpoint" {}
variable "rds_dbuser" {}
variable "rds_dbpassword" {}
variable "rds_dbname" {}

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