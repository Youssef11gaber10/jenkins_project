# 15_ create ec2 instance in public subnet (bastion host)
# 16_ create ec2 instance in private subnet (app server) have nginx webserver 

# bastion hub in public subnet
resource "aws_instance" "ec2_bastion_host_lab1_vpc" {
  # count = 1
  # count = var.bastion_host_count
  for_each = {for bastion in var.bastion_list : bastion.name => bastion} 
  
  # ami                         = "ami-09e320d375d7b8d3e"                                                  # ami for amazon linux 23
  ami                         = data.aws_ami.amazon_linux_23.id # get ami_id from data source
  # instance_type             = "t3.micro"      
  instance_type               = var.instance_type                                                          # t3.micro t2.micro not exist in stockholm
  # subnet_id                   = aws_subnet.public_subnet_terraform_lab1_vpc.id                           # public subnet 
  # subnet_id =  aws_subnet.subnet_terraform_lab1_vpc[count.index+2].id # to be in public subnet 2,3
  # subnet_id = aws_subnet.subnet_terraform_lab1_vpc["public_subnet_1"].id # filter wtih subnet name [public_subnet_1] instead of index [0]
    # subnet_id = aws_subnet.subnet_terraform_lab1_vpc["public_subnet_${count.index+1}"].id # filter wtih subnet name [public_subnet_1,public_subnet_2] instead of index [0],[1]

    # subnet_id = aws_subnet.subnet_terraform_lab1_vpc["public_subnet_${each.value.number}"].id
    subnet_id = module.network.NM_subnets["public_subnet_${each.value.number}"].id


  vpc_security_group_ids      = [aws_security_group.sg_bastion_host_lab1_vpc_allow_ssh_from_anywhere.id] # use bastion SG
  associate_public_ip_address = true                                                                     # create public ip
  key_name                    = "ssh-private-key"                                                        # use key pair this 
  tags = {
    # Name = "ec2_bastion_host_lab1_vpc"
    Name = each.value.name
  }




#   # provisioner "local-exec" {
#   #   command = "scp -i key-private-ec2.pem ./key-private-ec2.pem ec2-user@${self.public_ip}:~/" # move private key to bastion host
#   # }


#   # automatic without asking for fingreprint
#   provisioner "local-exec" {
#   # command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i key-private-ec2.pem ./key-private-ec2.pem ec2-user@${self.public_ip}:~/ && ssh -i key-private-ec2.pem ec2-user@${self.public_ip} && ls -lah "

#   command = <<EOT
# scp -o StrictHostKeyChecking=no \
#     -o UserKnownHostsFile=/dev/null \
#     -i key-private-ec2.pem \
#     ./key-private-ec2.pem \
#     ec2-user@${self.public_ip}:~/

# ssh -o StrictHostKeyChecking=no \
#     -o UserKnownHostsFile=/dev/null \
#     -i key-private-ec2.pem \
#     ec2-user@${self.public_ip} \
#     "ls -lah"
# EOT

#   # when = create
#   # when = destroy # work this command when destroy ec2

# }


connection { # connect to this machine after create it - stablish ssh connection with this credentials i give to hime 
  type = "ssh"
  user = "ec2-user"
  private_key = file("./ssh-private-key.pem")
  host = self.public_ip
}

provisioner "remote-exec" { # should provider him how he connect to remote machine first throw connection block , apply commands in this block
  inline = [ "echo 'hello from bastion host remote exec' && ls -lah ~/.   " ]
}

}

# webserver inside private subnet
resource "aws_instance" "ec2_webserver_lab1_vpc" {

  # count = 2 
  for_each = {for webserver in var.webserver_list : webserver.name => webserver} 

  # ami                    = "ami-07aacd2013ac45b9e" # ami for my ami have nginx on amazon linux 23
  # ami                    = data.aws_ami.nginx_my_ami.id # get ami_id from data source
  ami                    = data.aws_ami.amazon_linux_23.id
  
  # instance_type          = "t3.micro"
  instance_type          = var.instance_type
  # subnet_id              = aws_subnet.private_subnet_terraform_lab1_vpc.id                                      # put webserver in private subnet
  # subnet_id =  aws_subnet.subnet_terraform_lab1_vpc[count.index].id # to be in private subnet 0,1
  # subnet_id = aws_subnet.subnet_terraform_lab1_vpc["private_subnet_1"].id # filter wtih subnet name [private_subnet_1] instead of index [0]
    # subnet_id = aws_subnet.subnet_terraform_lab1_vpc["private_subnet_${count.index+1}"].id # filter wtih subnet name [private_subnet_1,private_subnet_2] instead of index [0],[1]
    # subnet_id = aws_subnet.subnet_terraform_lab1_vpc["private_subnet_${each.value.number}"].id
    subnet_id = module.network.NM_subnets["private_subnet_${each.value.number}"].id

  vpc_security_group_ids = [aws_security_group.sg_webserver_lab1_vpc_allow_ssh_and_3000_from_vpc_cider_only.id] # allow ssh and port 3000 from vpc cider (any one in vpc can connect to me on port 3000& 22)
  key_name               = "ssh-private-key"
  tags = {
    # Name = "ec2_webserver_lab1_vpc"
    Name = each.value.name
  }
}


resource "null_resource" "test" {
  provisioner "local-exec" { # this execute when the null resource is created # thsi command done on my local machine not on ec2
    command = "scp -i ssh-private-key.pem ./ssh-private-key.pem ec2-user@${aws_instance.ec2_bastion_host_lab1_vpc["bastion_host_1"].public_ip}:~/ && scp -i ssh-private-key.pem ./ssh-private-key.pem ec2-user@${aws_instance.ec2_bastion_host_lab1_vpc["bastion_host_2"].public_ip}:~/"
  }
  
}



resource "null_resource" "test-remote-exec" {

  depends_on = [ aws_instance.ec2_bastion_host_lab1_vpc["bastion_host_1"] ] # after create bastion host create this null resource so i can use remote-exec , i am sure the ec2 bastion host is created


connection { # connect to this machine after create it - stablish ssh connection with this credentials i give to hime 
  type = "ssh"
  user = "ec2-user"
  private_key = file("./ssh-private-key.pem")
  # host = aws_instance.ec2_bastion_host_lab1_vpc.public_ip # get public ip not from 'self.public_ip' because null resource is another different resource
  host = aws_instance.ec2_bastion_host_lab1_vpc["bastion_host_1"].public_ip # no count here is another resource 
}

provisioner "remote-exec" { # should provider him how he connect to remote machine first throw connection block , apply commands in this block
  inline = [ "echo 'hello from bastion host remote exec' && ls -lah ~/.   " ]
}
  
}