#Importing VPC module from  Terraform
module "VPC" {
  #Providing the source of module
  source = "terraform-aws-modules/vpc/aws"
  #Defining the Name
  name = "EKS"
  #Defining Availability zones
  azs = ["ap-south-1a","ap-south-1b","ap-south-1c"]
  #defining the cidr range for subnets
  private_subnets = ["10.0.0.0/24","10.0.1.0/24" ]
  public_subnets = ["10.0.4.0/24","10.0.5.0/24"]
  #Enabling Nat gateways
  enable_nat_gateway = true
  single_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true
}