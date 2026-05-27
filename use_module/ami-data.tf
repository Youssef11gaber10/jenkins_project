data "aws_ami" "amazon_linux_23" { # so i will fetch data of ami 
    most_recent = true # get the most recent image from this ami
    owners      = ["amazon"] # owner of this ami was amazon can be self (my-ami's) or amazon(general ami's)

    filter { # filter them by name
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-gp2"] # name of family of this
        # values = ["amzn-ami-hvm-*-x86_64-ebs"] # name of family of this 
    }
}

# data "aws_ami" "nginx_my_ami"{
#     most_recent = true 
#     owners      = ["self"]
#     filter {
#         name   = "name"
#         values = ["ec2-nginx"]
#     }
# }