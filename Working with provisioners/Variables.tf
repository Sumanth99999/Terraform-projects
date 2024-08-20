variable "cidr_block" {
  description = "Default value for cidr blocks"
  default = "10.0.0.0/16"
}
variable "subnet-1" {
  description = "Default value for subnet-2"
  default = "10.0.0.0/24"
}
variable "subnet-2" {
  description = "Default value for subnet-2"
  default = "10.0.0.0/24"
}

variable "default-ami" {
  description = "Default value for AMI"
  default = "ami-0ad21ae1d0696ad58"
}

variable "default-instance-type" {
  description = "Default value for instance type"
  default = "t2.micro"
}