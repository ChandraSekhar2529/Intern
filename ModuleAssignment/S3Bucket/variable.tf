variable "bucket_prefix"{
	type = string
	description = "Creates S3 bucket"
	default = "my-s3-bucket-"


}

variable "tags"{
	type = map
	default={
		terraform = true,
		environment = "DEV"
	}

}

variable "acl"{
	type = string
	default = "private"
}
