variable "ami-id" {
  description = "default ami for instance"
  default = "ami-0ad21ae1d0696ad58"
}


variable "instance-type" {
  description = "default instance type"
  default = "t2.micro"
}

variable "cidr_range" {
  description = "default cidr range"
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "default subnet cidr range"
  default = "10.0.0.0/24"
}