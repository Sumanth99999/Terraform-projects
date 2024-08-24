module "VPC" {
  source = "terraform-aws-modules/vpc/aws"
  name = "EKS"
  azs = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  private_subnets = ["10.0.0.0/24","10.0.1.0/24" ]
  public_subnets = ["10.0.4.0/24","10.0.5.0/24"]
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true
}