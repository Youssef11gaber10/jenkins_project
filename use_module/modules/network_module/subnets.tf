# # private subnet 
# resource "aws_subnet" "private_subnet_terraform_lab1_vpc" {
#   # count = 2
#   vpc_id     = aws_vpc.terraform_lab1_vpc.id
#   # cidr_block = "10.100.1.0/24"
#   cidr_block = var.private_subnet_cidr
#     availability_zone = "${var.region}a" # to be region+(a,b,c) eu-north-1a,eu-north-1b,eu-north-1c
#   tags = {
#     Name = "private_subnet_terraform_lab1_vpc"
#   }
# }

# # public subnet 
# resource "aws_subnet" "public_subnet_terraform_lab1_vpc" {
#   # count = 2 # you have now 2 public subnets so when you make referencce to one of them must specify which one public-subnet[0] or public-subnet[1]
#   vpc_id     = aws_vpc.terraform_lab1_vpc.id
#   # cidr_block = "10.100.2.0/24"
#   cidr_block = var.public_subnet_cidr

#     availability_zone = "${var.region}b" # not mandantory to be in same az

#   map_public_ip_on_launch = true # to have public ip for each resource added to this public subnet , or you can make public ip with each resource you decide
#   tags = {
#     Name = "public_subnet_terraform_lab1_vpc"
#   }
# }


# # general subnet 
# resource "aws_subnet" "subnet_terraform_lab1_vpc" {
  
#   count = var.subnet_count # you have now 2 public subnets so when you make referencce to one of them must specify which one public-subnet[0] or public-subnet[1]
  
#   vpc_id     = aws_vpc.terraform_lab1_vpc.id
#   # cidr_block = "10.100.2.0/24"
#   # cidr_block = var.public_subnet_cidr
#   cidr_block = var.subnet_cidr[count.index] # will be [0],[1],[2],[3] each time create subnet with new cidr 1,2 private 3,4 public

#     # availability_zone = "${var.region}b" # here all of them will be in same AZ  if yo want to make it variable make list (a,b,c) switch between them over index
#     availability_zone = "${var.region}${var.AZ_letters[count.index]}" # region +(a,b,c) eu-north-1a,eu-north-1b,eu-north-1c

#   map_public_ip_on_launch = var.public_ip_available[count.index] # first 2 private will be false and other 2 will be true public # also make it list but need to remeber 1,2 private 3,4 public

#   tags = {
#     Name = "${var.tag_subnet_name[count.index]}_subnet${count.index}_terraform_lab1_vpc" # first 2 private 2 and other 2 public
#   }
# }



# general subnet 
resource "aws_subnet" "subnet_terraform_lab1_vpc" {
  
  vpc_id     = aws_vpc.terraform_lab1_vpc.id

  for_each = { for subnet in var.subnet_variables_list : subnet.name => subnet } # i choose subnet.name identify each subnet instead of index [0],[1],[2],[3] -> private-subnet1 or public-subnet1 , private-subnet2 or public-subnet2

  #   count = var.subnet_count # you have now 2 public subnets so when you make referencce to one of them must specify which one public-subnet[0] or public-subnet[1]

  # cidr_block = var.subnet_cidr[count.index] # will be [0],[1],[2],[3] each time create subnet with new cidr 1,2 private 3,4 public
  cidr_block = each.value.subnet_cidr 

    # availability_zone = "${var.region}${var.AZ_letters[count.index]}" # region +(a,b,c) eu-north-1a,eu-north-1b,eu-north-1c
    availability_zone = "${var.region}${each.value.AZ_letters}" # region +(a,b,c,a) eu-north-1a,eu-north-1b,eu-north-1c

  # map_public_ip_on_launch = var.public_ip_available[count.index] # first 2 private will be false and other 2 will be true public # also make it list but need to remeber 1,2 private 3,4 public
  map_public_ip_on_launch = each.value.type == "public" ? true : false # if type of subnet is public will be true, if not will be false

  tags = {
    # Name = "${var.tag_subnet_name[count.index]}_subnet${count.index}_terraform_lab1_vpc" # first 2 private 2 and other 2 public
    Name = "${each.value.name}_terraform_lab1_vpc"
  }
}