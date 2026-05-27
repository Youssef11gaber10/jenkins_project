output "rds_endpoint" {
  description = "RDS_ENDPoint"
  value = aws_db_instance.db_instnace.endpoint
}

output "rds_master_username" {
    value= aws_db_instance.db_instnace.username
}

output "rds_master_password" {
    value= aws_db_instance.db_instnace.password
    sensitive = true # not show in terminal but if you order to show it will show-> terraform output -s 
}