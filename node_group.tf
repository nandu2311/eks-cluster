
resource "aws_eks_node_group" "nodes_general" {
  cluster_name    = aws_eks_cluster.my_eks_cluster.id
  node_group_name = "nodes_general"
  node_role_arn   = aws_iam_role.nodes_general_iam_role.arn
  subnet_ids = [
    aws_subnet.private-sub1.id,
    aws_subnet.private-sub2.id
  ]
  instance_types = ["t2.micro"]


  scaling_config {
    #Desired number of worker nodes
    desired_size = 1

    #maximum number of worker nodes
    max_size = 1

    #minimum number of worker nodes
    min_size = 1
  }

  #TYPES OF Amazon machine images (AMI) associated with eks node group
  #valid_values: AL2_x86_64 AL2_x86_64_GPU AL2_ARM_64 CUSTOM BOTTLEROCKET_ARM_64 BOTTLEROCKET_x86_64 BOTTLEROCKET_ARM_64_NVIDIA BOTTLEROCKET_x86_64_NVIDIA WINDOWS_CORE_2019_x86_64 WINDOWS_FULL_2019_x86_64 WINDOWS_CORE_2022_x86_64 WINDOWS_FULL_2022_x86_64
  /* ami_type = "AL2_x86_64" */

  #Types of capacity associated with eks nodes group
  #valid_values: ON_DEMAND, SPOT
  /* capacity_type = "ON_DEMAND" */

  #Disk size in GiB for worker nodes
  /* disk_size = 30 */

  force_update_version = false


 

  depends_on = [
    aws_iam_role_policy_attachment.node_policy_general,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ec2_container_registry_read_only,
  ]
  
  labels = {
      "role" = "nodes-general"
    }
}