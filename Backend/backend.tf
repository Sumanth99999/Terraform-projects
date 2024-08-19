terraform {
  backend "s3" {
    bucket = "narusumanthreddy.com"
    region = "ap-south-1"
    key = "Terraform/terraform.tfstate"
  }
}