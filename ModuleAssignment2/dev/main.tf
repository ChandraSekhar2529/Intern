provider "aws"{
    region = "ap-south-1"
}
module "my_vpc"{
    source = "../modulesT/vpc"
    vpc_cidr = "10.0.0.0/16"
    vpc_name = "myVpc"
    public_subnet_cidr = "10.0.100.0/24"
    private_subnet_cidr = "10.0.200.0/24"
    vpc_id = "${module.my_vpc.vpc_id}"
}

module "myEc2"{
    source = "../modulesT/ec2"
    instance_type = "t2.micro"
    ami = "ami-0c6615d1e95c98aca"
    subnet_id = "${module.my_vpc.subnet_id}"
}
