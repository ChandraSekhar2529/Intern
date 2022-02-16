variable "vpc_id"{
	type =string
	description = "VPC id"
	default="my-s3-bucket-"
}

variable "cidr_block"{
	type = string
	description ="subnet cidr_block"
}

variable "webserver_name"{
	type=string
	description ="webserver name"

}

variable "ami"{
	type = string
	description = "AMI to use foe webserver"
}

variable "instance_type"{
	type = string
	description = "instance type"

}
