resource "aws_eks_cluster" "bedrock_cluster" {
  name     = "${var.cluster_name}-${random_string.suffix.result}"
  role_arn = aws_iam_role.cluster_role.arn
  version  = "1.31"

  vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
    endpoint_private_access = true   
    endpoint_public_access  = true   
    subnet_ids              = data.aws_subnets.default.ids
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true 
  }

  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_cluster_policy
  ]
}

# Launch Template updated to t3.micro for Free Tier compliance in managed node groups
resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "eks-nodes-${random_string.suffix.result}-"
  instance_type = "t3.micro" # <-- Updated here!

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.eks_nodes_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "project-bedrock-worker-node"
    }
  }
}

resource "aws_eks_node_group" "bedrock_nodes" {
  cluster_name    = aws_eks_cluster.bedrock_cluster.name
  node_group_name = "project-bedrock-worker-nodes"
  node_role_arn   = aws_iam_role.node_role.arn
  subnet_ids      = data.aws_subnets.default.ids

  instance_types = ["t3.micro"] # <-- Updated here!

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = aws_launch_template.eks_nodes.latest_version
  }

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
    aws_launch_template.eks_nodes
  ]
}