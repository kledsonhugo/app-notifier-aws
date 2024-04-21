variable "vpc_id" {}
variable "vpc_cidr" {}
variable "vpc_sn_priv_az1_id" {}
variable "vpc_sn_priv_az2_id" {}

variable "rds_sn_group_name" {
  type    = string
  default = "rds-sn-group-name"
}

variable "rds_param_group_name" {
  type    = string
  default = "rds-param-group-name"
}

variable "rds_identifier" {
  type    = string
  default = "rds-identifier"
}

variable "rds_family" {
  type    = string
  default = "mysql8.0"
}

variable "rds_engine" {
  type    = string
  default = "mysql"
}

variable "rds_engine_version" {
  type    = string
  default = "8.0.28"
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "rds_dbname" {
  type    = string
  default = "rdsdbname"
}

variable "rds_dbuser" {
  type    = string
  default = "rdsdbuser"
}

variable "rds_dbpassword" {
  type    = string
  default = "rdsdbpassword"
}

variable "rds_multi_az" {
  type    = bool
  default = false
}