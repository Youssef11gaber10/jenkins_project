output "vpc_id" {
  # value= aws_vpc.terraform_lab1_vpc.id
  value= module.network.NM_vpc_id
}

output "ec2_bastion_public_ip" {
  value= aws_instance.ec2_bastion_host_lab1_vpc["bastion_host_1"].public_ip
}

output "rds_endpoint" {
  value = module.rds.rds_endpoint
}

output "rds_master_username" {
  value = module.rds.rds_master_username
}

output "rds_master_password" {
  value = module.rds.rds_master_password
  sensitive = true
}

output "redis_endpoint" {
    value = module.elasicache.redis_endpoint
}

output  "redis_port" {
    value = module.elasicache.redis_port
}