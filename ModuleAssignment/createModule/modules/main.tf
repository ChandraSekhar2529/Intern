terraform {
	required_version = ">= 0.12"
}

resource "aws_subnet" "webserver"{
	vpc_id = var.vpc_id
	cidr_block = var.cidr_block
}


resource "aws_instance" "server"{
	
	ami = var.ami
	instance_type = var.instance_type
	subnet_id  = aws_subnet.webserver.id
	tags={
		Name ="${var.webserver_name} Webserver"
	}
}


resource "aws_eip" "lb" {
  instance = aws_instance.server.id
  vpc      = true
}
resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.lb.id
  subnet_id     = aws_subnet.webserver.id
}

resource "aws_internet_gateway" "gw" {
  vpc_id = var.vpc_id
}

