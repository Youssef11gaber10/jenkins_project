#rds need to have subnet group so you can make new one for it 
    # crate vpc with subnets & make subnet group of these vpcs 
# but i will use vpc creaed of public subnet to be public accessible & make subnet group of them
#-------------
#need to make SG of rds to be accessible from outside allow tcp 3306 from any wher , or the correct allow 3306 from vpc cider only 
    # make bastion host in public subnet and subnet group be in private subent and connect to db from bastion 


resource "aws_security_group" "sg-db-instance-allow-tcp-3306-from-anywhere" {
  name   = "sg_db_instance_allow_tcp_3306_from_anywhere"
  # vpc_id = module.network.NM_vpc_id # i can't refer to network module # so make it as variable and provide its value from main.tf (sees network module)
  vpc_id=var.vpc_id
  ingress {          # come to me (anywhere 0.0.0.0/0)
    from_port   = 3306 # here from & to to define range of ports 
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # anywhere can connect to me on port 3306
  }
  egress { # this is mandatory in terraform
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_db_instance_allow_tcp_3306_from_anywhere"
  }
  
}

# create subnet group for rds , i will choose private subnet to be in private subnet group
resource "aws_db_subnet_group" "subnet_group_db_mysql" {
  name       = "subnet_group_db_mysql"
  # subnet_ids = [module.network.NM_subnets["private_subnet_1"].id, module.network.NM_subnets["private_subnet_2"].id]
  subnet_ids = [var.private_subnet_1_id, var.private_subnet_2_id]

  tags = {
    Name = "subnet_group_db_mysql"
  }
  
}


# create rds instance

resource "aws_db_instance" "db_instnace" {
 # engine 
 engine= "mysql"
 engine_version= "8.4.8"
 instance_class= "db.t3.micro"

 #storage 
 allocated_storage= 20
 max_allocated_storage = 100
 storage_type = "gp2"
#  storage_encrypted = true

# database credentials
 db_name= "${var.project_name}_mysql_db_${var.env}"# mysql-db
 # username 
 username= var.db_username #admin # make it as variable also , the guy want to use module just provide username, password and i will create db for him
 # password 
 password= var.db_password  # password # make it as sensitive variable

 #network
 db_subnet_group_name= aws_db_subnet_group.subnet_group_db_mysql.name
 # instance SG
 vpc_security_group_ids= [aws_security_group.sg-db-instance-allow-tcp-3306-from-anywhere.id]
publicly_accessible = true

# for deletion 
skip_final_snapshot = true # set false in production
deletion_protection = false # set true in production



tags={
    Name="${var.project_name}_RDS"
    Environemtn="${var.env}"
}

  
}