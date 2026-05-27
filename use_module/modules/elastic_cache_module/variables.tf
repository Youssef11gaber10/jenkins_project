variable "vpc_id" {
  type = string
}

variable "private_subnet_1_id" {
  type = string
}
variable "private_subnet_2_id" {
  type = string
}

variable "project_name" {
    type = string
    default = "terraform_lab1"
}

variable "env" {
    type = string
    default = "dev"
}
