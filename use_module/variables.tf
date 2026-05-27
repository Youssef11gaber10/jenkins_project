variable "vpc_cidr" {
    type = string
    default = "10.100.0.0/16"
  
}
variable "region" {
    type = string
    # default = "eu-north-1" # use this in AZ ${var.region}a , ${var.region}b , ${var.region}c
  
}

variable "subnet_variables_list" {
  type = list(object({
    name = string, # private-subnet1 or public-subnet1 , private-subnet2 or public-subnet2
    subnet_cidr = string, # 
    AZ_letters = string,# region +(a,b,c)
    type = string # private or public # to make condition of allow public ip or not
  }))
}

variable "bastion_list" { # replace count in webserver & bastion host to names instead of index
  type = list(object({
      name = string
      number = number # needed instead of index to select subnet-1 , subnet-2 
  }))  
}

variable "webserver_list" { # replace count in webserver & bastion host to names instead of index
  type = list(object({
      name = string
      number = number # needed instead of index to select subnet-1 , subnet-2 
  }))  
}




variable "instance_type" {
  type = string
  default = "t2.micro"
}


# variable "bastion_host_count" {
#   type = number
#   default = 0
# }


variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "db_username" {
  type = string
  # default = "admin"
}

variable "db_password" {
  type = string
  sensitive = true
}