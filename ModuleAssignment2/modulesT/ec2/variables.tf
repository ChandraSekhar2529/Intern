variable "instance_type"{
    type = string
    default = "t2.micro"
}
variable "ami" {
  type        = string
  default     = "ami-02a45d709a415958a"
  
}

variable "subnet_id" {
  type        = string
}
