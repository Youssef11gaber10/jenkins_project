output "NM_subnets" { # ths get subnet object consist of 4 subnets i can traverse inside of them use (public-subnet1, public-subnet2, private-subnet1, private-subnet2)
    value= aws_subnet.subnet_terraform_lab1_vpc # give me all subnet i can use them 
}

output "NM_vpc_id" {
  value = aws_vpc.terraform_lab1_vpc.id
}

output "NM_vpc_cidr" {
  value = aws_vpc.terraform_lab1_vpc.cidr_block
}