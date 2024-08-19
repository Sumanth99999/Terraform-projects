
variable "ami" {
  description = "default ami"
}

variable "instance_type" {
  description = "default instance type"
  type = map(string)
  default = {
    "dev" = "t2.medium"
    "test" = "t2.micro"
  }

}
