# RESOURCE: DB SUBNET GROUP

resource "aws_db_subnet_group" "rds_sn_group" {
    name       = "${var.rds_sn_group_name}"
    subnet_ids = ["${var.vpc_sn_priv_az1_id}", "${var.vpc_sn_priv_az2_id}"]
}


# RESOURCE: DB PARAMETER GROUP

resource "aws_db_parameter_group" "rds_param_group" {
    name   = "${var.rds_param_group_name}"
    family = "${var.rds_family}"
    parameter {
        name  = "character_set_server"
        value = "${var.rds_charset}"
    }
    parameter {
        name  = "character_set_database"
        value = "${var.rds_charset}"
    }
}


# RESOURCE: DB INSTANCE

resource "aws_db_instance" "rds_dbinstance" {
    identifier             = "${var.rds_identifier}"
    engine                 = "${var.rds_engine}"
    engine_version         = "${var.rds_engine_version}"
    instance_class         = "${var.rds_instance_class}"
    storage_type           = "${var.rds_storage_type}"
    allocated_storage      = "${var.rds_allocated_storage}"
    max_allocated_storage  = "${var.rds_max_allocated_storage}"
    monitoring_interval    = "${var.rds_monitoring_interval}"
    db_name                = "${var.rds_dbname}"
    username               = "${var.rds_dbuser}"
    password               = "${var.rds_dbpassword}"
    skip_final_snapshot    = "${var.rds_skip_final_snapshot}"
    multi_az               = "${var.rds_multi_az}"
    db_subnet_group_name   = aws_db_subnet_group.rds_sn_group.name
    parameter_group_name   = aws_db_parameter_group.rds_param_group.name
    vpc_security_group_ids = ["${var.vpc_sg_priv_id}"]
}