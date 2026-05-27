#IGW
resource "aws_internet_gateway" "igw_terraform_lab1_vpc" {
  vpc_id = aws_vpc.terraform_lab1_vpc.id
  tags = {
    Name = "igw_terraform_lab1_vpc"
  }
}