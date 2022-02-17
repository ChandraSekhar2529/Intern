variable  "apiName" {
  type        = string
  default     = "StudentsInfo"
  
}

variable "path_part" {
  type        = string
  default     = "students"
}
variable "stageName" {
  type        = string
  default     = "version1"
}

variable "invoke_arn" {
  type        = string
}

variable "function_name" {
  type        = string
}



