provider "aws"{
	region = "us-west-1"
}

resource "aws_vpc" "myVpc"{
	cidr_block = "10.0.0.0/16"	
}



module "chandra_webserver"{
	source = "../modules/webserver"
	vpc_id = aws_vpc.myVpc.id
	cidr_block = "10.0.0.0/16"
	webserver_name = "chandra"
	ami = "ami-03af6a70ccd8cb578"
	instance_type="t2.micro"
	
        
}



