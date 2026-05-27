# in main.tf collect module i used and give its values and start use them in my code(resources)
module "network" {
    source = "./modules/network_module" # now ask you for variables values to use this module

subnet_variables_list = var.subnet_variables_list # this take its value from .tfvars
region = var.region # this take its value from .tfvars
vpc_cidr = var.vpc_cidr # this take its value from .tfvars

    # you can put the required variable explicit like this or put them in variable.tf & .tfvars refer to this variable.tf and then use them here
#     subnet_variables_list =  [ { # required 
#     name = "private_subnet_1", # private or public & use this as condition also not just in name
#     subnet_cidr = "10.100.1.0/24", # 
#     AZ_letters = "a",# region +(a,b,c)
#     type = "private" # private or public # to make condition of allow public ip or not
#   },
#   {
#     name = "private_subnet_2", 
#     subnet_cidr = "10.100.2.0/24", 
#     AZ_letters = "b",
#     type = "private" 
#   },
#   {
#     name = "public_subnet_1",
#     subnet_cidr = "10.100.3.0/24", 
#     AZ_letters = "c",
#     type = "public" 
#   },
#   {
#     name = "public_subnet_2", 
#     subnet_cidr = "10.100.4.0/24", 
#     AZ_letters = "a",
#     type = "public" 
#   }
# ]
# region = "eu-north-1" # required

# vpc_cidr = "10.100.0.0/16" # required
  
}


module "rds" {
    source = "./modules/rds_module"

    project_name = var.project_name
    env = var.env
    db_username = var.db_username
    db_password = var.db_password

    vpc_id = module.network.NM_vpc_id
    private_subnet_1_id = module.network.NM_subnets["private_subnet_1"].id
    private_subnet_2_id = module.network.NM_subnets["private_subnet_2"].id
    depends_on = [ module.network ]
}

module "elasicache" {
  source = "./modules/elastic_cache_module"
  env = var.env
  project_name = var.project_name
  vpc_id = module.network.NM_vpc_id
  private_subnet_1_id = module.network.NM_subnets["private_subnet_1"].id
  private_subnet_2_id = module.network.NM_subnets["private_subnet_2"].id
  depends_on = [ module.network ]

}