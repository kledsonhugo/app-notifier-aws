# NETWORK VARS DEFAULT VALUES
variable "vpc_cidr" {
  type    = string
  default = "20.0.0.0/16"
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
  default = "20.0.1.0/24"
}

variable "vpc_sn_pub_az2_cidr" {
  type    = string
  default = "20.0.2.0/24"
}

variable "vpc_sn_priv_az1_cidr" {
  type    = string
  default = "20.0.3.0/24"
}

variable "vpc_sn_priv_az2_cidr" {
  type    = string
  default = "20.0.4.0/24"
}