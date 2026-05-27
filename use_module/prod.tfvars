
vpc_cidr="10.250.0.0/16" # but in "" cause its type is string 


region = "eu-central-1"# frankfurt

instance_type = "t3.micro"


subnet_variables_list = [ {
    name = "private_subnet_1", # private or public & use this as condition also not just in name
    subnet_cidr = "10.250.1.0/24", # 
    AZ_letters = "a",# region +(a,b,c)
    type = "private" # private or public # to make condition of allow public ip or not
  },
  {
    name = "private_subnet_2", 
    subnet_cidr = "10.250.2.0/24", 
    AZ_letters = "b",
    type = "private" 
  },
  {
    name = "public_subnet_1",
    subnet_cidr = "10.250.3.0/24", 
    AZ_letters = "c",
    type = "public" 
  },
  {
    name = "public_subnet_2", 
    subnet_cidr = "10.250.4.0/24", 
    AZ_letters = "a",
    type = "public" 
  }
]

bastion_list = [ {
  name = "bastion_host_1",
  number = 1
} ,
{
  name = "bastion_host_2",
  number = 2
} 
]

webserver_list = [ 
{
  name = "webserver_1",
  number = 1
} ,
{
  name = "webserver_2"
  number = 2
} 
]


# bastion_host_count = 2



