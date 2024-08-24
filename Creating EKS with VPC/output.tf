#Printing Clusterid 
output "cluster_id" {
  description = "Cluster id"
  value = module.EKS.cluster_id
}
#Printing Cluster End point
output "cluster_end_point" {
  description = "Cluster endpoint"
  value = module.EKS.cluster_endpoint
}
#Printing Security Group id
output "sg_id" {
  description = "Security Group Id"
  value = aws_security_group.rule.id
}
#Printing AWS Region
output "region" {
description = "Aws Region"
  value = var.AWS_region
}