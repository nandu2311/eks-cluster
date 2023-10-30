resource "aws_iam_role" "nodes_general_iam_role" {
  name               = "node_general_iam_role"
  assume_role_policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
            }
        ]
    }
 EOF 

}

#IAM policy attachment inhouse policys using here (AmazonEKSWorkerNodePolicy)
resource "aws_iam_role_policy_attachment" "node_policy_general" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes_general_iam_role.name

}

#IAM policy attachment inhouse policys using here (AmazonEKS_CNI_Policy)
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes_general_iam_role.name

}

#IAM policy attachment inhouse policys using here (AmazonEC2ContainerRegistryReadOnly)
resource "aws_iam_role_policy_attachment" "ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes_general_iam_role.name
}
 
 resource "aws_iam_role_policy_attachment" "EC2InstanceProfileForImageBuilderECRContainerBuilds" {
  policy_arn = "arn:aws:iam::aws:policy/EC2InstanceProfileForImageBuilderECRContainerBuilds"
  role    = aws_iam_role.nodes_general_iam_role.name
 }