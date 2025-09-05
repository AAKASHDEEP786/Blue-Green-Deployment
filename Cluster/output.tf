output "cluster_id" {
  value = aws_eks_cluster.skyopsx.id
}

output "node_group_id" {
  value = aws_eks_node_group.skyopsx.id
}

output "vpc_id" {
  value = aws_vpc.skyopsx_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.skyopsx_subnet[*].id
}

