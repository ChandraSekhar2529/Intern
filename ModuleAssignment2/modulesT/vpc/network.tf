
resource "aws_vpc" "sampleVpc"{
    cidr_block = "${var.vpc_cidr}"
    tags = {
        Name = "${var.vpc_name}"
    }
}

resource "aws_internet_gateway" "sampleIGW"{
    vpc_id = aws_vpc.sampleVpc.id
    tags = {
        Name = "igw2601"
    }
}

resource "aws_subnet" "subnets"{
    vpc_id = aws_vpc.sampleVpc.id
    for_each={
        public = "${var.public_subnet_cidr}"
        private = "${var.private_subnet_cidr}"
    }
    
    cidr_block = each.value

    tags = {
        Name = "${each.key}"
    }
}
# resource "aws_subnet" "samplePrivate"{
#     vpc_id = aws_vpc.sampleVpc.id
#     cidr_block = "10.0.200.0/24" 

#     tags = {
#         Name = "Private"
#     }
# }

resource "aws_route_table" "PublicRT"{
    vpc_id = aws_vpc.sampleVpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.sampleIGW.id
    }
}
resource "aws_route_table" "PrivateRT"{
    vpc_id = aws_vpc.sampleVpc.id
}

resource "aws_route_table_association" "association" {

    for_each = {
        pub = [
              aws_subnet.subnets["public"].id,
              aws_route_table.PublicRT.id
        ]
        pri = [
              aws_subnet.subnets["private"].id,
              aws_route_table.PrivateRT.id
        ]
    }
    subnet_id = each.value[0]
    route_table_id = each.value[1]
 
  
}


# resource "aws_route_table_association" "pub" {
#   subnet_id      = aws_subnet.samplePublic.id
#   route_table_id = aws_route_table.PublicRT.id
# }

# resource "aws_route_table_association" "pri" {
#   subnet_id      = aws_subnet.samplePrivate.id
#   route_table_id = aws_route_table.PrivateRT.id
# }

# resource "aws_instance" "instances"{
#     instance_type  = "t2.micro"
#     ami = "ami-0c6615d1e95c98aca"
#     key_name = "Traveller"
#     for_each = {
#         public = aws_subnet.subnets["public"].id
#        // private = aws_subnet.subnets["private"].id
#     }
#     subnet_id = each.value

#     tags = {
#         Name = "${each.key}Instance"
#     }
# }
# resource "aws_instance" "instancePri"{
#     instance_type  = "t2.micro"
#     ami = "ami-0e472ba40eb589f49"
#     key_name = "Traveller"
#     subnet_id      = aws_subnet.samplePrivate.id

#     tags = {
#         Name = "PrivateInstance"
#     }
# }

output "vpc_id" {
  value       = "${aws_vpc.sampleVpc.id}"

}
output "subnet_id" {
  value       = "${aws_subnet.subnets["public"].id}"
}
