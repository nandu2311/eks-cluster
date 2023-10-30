
output "vpc_id" {
  value       = aws_vpc.eks-vpc.id
  description = "VPC Id"
}

