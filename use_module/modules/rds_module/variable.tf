variable "project_name" {
    type = string
    default = "terraform_lab1"
}

variable "env" {
    type = string
    default = "dev"
}

variable "db_username" {
    type = string
    # default = "admin"
}

variable "db_password" {
    description = "RDS master pasword"
    type = string
    sensitive = true # not provide this value in tfvars , take it from terminal
}


variable "vpc_id" {
    type = string
}
variable "private_subnet_1_id" {
  type = string
}
variable "private_subnet_2_id" {
  type = string
}