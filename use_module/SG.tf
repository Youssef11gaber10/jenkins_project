#create Security groups for ec2 instances 
# 13_ create security group for ec2 instance in public subnet (bastion host ) allow ssh from 0.0.0.0/0
# 14_ create security group for ec2 instance in private subnet (app server) allow ssh from bastion host security group/vpc cider only 

resource "aws_security_group" "sg_bastion_host_lab1_vpc_allow_ssh_from_anywhere" {
  name   = "sg_bastion_host_lab1_vpc"
  # vpc_id = aws_vpc.terraform_lab1_vpc.id
  vpc_id = module.network.NM_vpc_id
  ingress {          # come to me (anywhere 0.0.0.0/0)
    from_port   = 22 # here from & to to define range of ports 
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # any one can connect to me on port 22
  }
  egress { # this is mandatory in terraform
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_bastion_host_lab1_vpc_allow_ssh_from_anywhere"
  }
}

resource "aws_security_group" "sg_webserver_lab1_vpc_allow_ssh_and_3000_from_vpc_cider_only" {
  name   = "sg_webserver_lab1_vpc" # add this
  # vpc_id = aws_vpc.terraform_lab1_vpc.id
  vpc_id = module.network.NM_vpc_id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = [aws_vpc.terraform_lab1_vpc.cidr_block] # any resource inside vpc can connect to me on port 22
    cidr_blocks = [module.network.NM_vpc_cidr]
  }
  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    # cidr_blocks = [aws_vpc.terraform_lab1_vpc.cidr_block] # any resource inside vpc can connect to me on port 3000
    cidr_blocks = [module.network.NM_vpc_cidr]
  }
  ingress { # can connect to me on port 80 to access nginx webserver
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    # cidr_blocks = [aws_vpc.terraform_lab1_vpc.cidr_block] # any resource inside vpc can connect to me on port 3000
    cidr_blocks = [module.network.NM_vpc_cidr]
  }
  egress { # this is mandatory in terraform
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg_webserver_lab1_vpc_allow_ssh_and_3000_from_vpc_cider_only"
  }

}

# resource "aws_security_group" "sg_webserver_lab1_vpc_allow_ssh_and_3000_from_SG_bastion_host_only" { # more secure not allow any resource inside my vpc just the resources use SG_bastion_host _> only the bastion host can connect to me 
#   # vpc_id = aws_vpc.terraform_lab1_vpc.id
#   vpc_id = module.network.NM_vpc_id
#   ingress {
#     from_port       = 22
#     to_port         = 22
#     protocol        = "tcp"
#     security_groups = [aws_security_group.sg_bastion_host_lab1_vpc_allow_ssh_from_anywhere.id] # allow only the bastion host
#   }
#   ingress {
#     from_port       = 3000
#     to_port         = 3000
#     protocol        = "tcp"
#     security_groups = [aws_security_group.sg_bastion_host_lab1_vpc_allow_ssh_from_anywhere.id] # allow only the bastion host
#   }
#   ingress { # can connect to me on port 80 to access nginx webserver
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = [aws_security_group.sg_bastion_host_lab1_vpc_allow_ssh_from_anywhere.id] # any resource inside vpc can connect to me on port 3000
#   }
#   egress { # this is mandatory in terraform
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name = "sg_webserver_lab1_vpc_allow_ssh_and_3000_from_SG_bastion_host_only"
#   }

# }

