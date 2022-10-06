# DATABASE OUTPUT TO BE REUSED

output "rds_endpoint" {
    value = "${aws_db_instance.rds_dbinstance.endpoint}"
}