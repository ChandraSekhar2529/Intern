variable  "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
 
}

variable  "vpc_name" {
  type        = string
  default     = "mainVPC"
 
}
variable "public_subnet_cidr"{
    type = string
    default  = "10.0.100.0/24"
}
variable "private_subnet_cidr"{
    type = string
    default  = "10.0.200.0/24"
}

variable "vpc_id" {
  type        = string
}
