resource "aws_eks_cluster" "my_eks_cluster" {
  #name of the cluster
  name = "my_eks_cluster"

  #iam role that provides permission for kubernetes control plan to make calls to aws api operations
  role_arn = aws_iam_role.eks_cluster_role.arn

  #desired kubernetes master version
  version = "1.23"

  /* manage_aws_auth_configmap = true */

  vpc_config {
    #Indicates whether or not the Amazon eks private api server endpoint is enabled 
    endpoint_private_access = false

    #amazon eks public api server endpoint is enabled
    endpoint_public_access = true

    subnet_ids = [
      aws_subnet.public-sub1.id,
      aws_subnet.public-sub2.id,
      aws_subnet.private-sub1.id,
      aws_subnet.private-sub2.id,
    ]
  }

  depends_on = [
      aws_iam_role.eks_cluster_role
  ]


}