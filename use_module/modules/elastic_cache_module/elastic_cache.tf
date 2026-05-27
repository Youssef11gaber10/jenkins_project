# create SG for elastic cache instances
resource "aws_security_group" "sg-elastic-cache-allow-tcp-6379-from-anywhere" {
    name   = "sg_elastic_cache_instances_allow_tcp_6379_from_anywhere"
    vpc_id=var.vpc_id # this sg will be in which vpc
    ingress {          # come to me (anywhere 0.0.0.0/0)
        from_port   = 6379 # here from & to to define range of ports 
        to_port     = 6379
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] # anywhere can connect to me on port 3306
    }
    egress { # this is mandatory in terraform
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg_elastic_cache_allow_tcp_6379_from_anywhere"
    }
}


# create subnet group from priavate subnets of vpc
resource "aws_elasticache_subnet_group" "subnet_group" {
    name = "elastic-cache-subnet-group"
    subnet_ids = [var.private_subnet_1_id, var.private_subnet_2_id]
    tags = {
      Name= "MY cache subnet group"
    }
}


# create elastic cache cluster
resource "aws_elasticache_cluster" "redis_cluster" {
    #name
    # cluster_id = "${var.project_name}-redis-cluster-${var.env}" # name of cluster
    cluster_id = "my-redis-cluster"
    #Engine
    engine = "redis"
    engine_version = "7.1"
    node_type = "cache.t3.micro"
    num_cache_nodes =  1
    port = 6379
    subnet_group_name = aws_elasticache_subnet_group.subnet_group.name
    security_group_ids = [aws_security_group.sg-elastic-cache-allow-tcp-6379-from-anywhere.id]
}