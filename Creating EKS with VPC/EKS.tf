module "EKS" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name = "EKS"
  cluster_version = "1.30"
  vpc_id = module.VPC.vpc_id
  subnet_ids = module.VPC.private_subnets
  enable_irsa = true

  eks_managed_node_group_defaults = {
   ami_type               = "AL2_x86_64"
   instance_types         = ["t3.medium"]
   vpc_security_group_ids = [aws_security_group.rule.id]
  }

  eks_managed_node_groups = {
    node_group={
        min_size = 2
        max_size = 6
        desired_size = 2
    }
  }
}