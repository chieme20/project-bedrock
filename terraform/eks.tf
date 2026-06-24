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

# Fetch the official Amazon EKS Optimized AMI for the node handshake
data "aws_ami" "eks_worker" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-1.31-v*"]
  }
  most_recent = true
  owners      = ["602401143452"] # Amazon EKS Owner ID
}

# Launch Template with the explicit EKS bootstrap script
resource "aws_launch_template" "eks_nodes" {
  name_prefix   = "eks-nodes-${random_string.suffix.result}-"
  image_id      = data.aws_ami.eks_worker.id
  instance_type = "t3.micro"

  iam_instance_profile {
    name = aws_iam_instance_profile.node_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.eks_nodes_sg.id]
  }

  # This script forces the instance to instantly shake hands with the cluster over the public internet
  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh ${var.cluster_name}-${random_string.suffix.result}
    EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "project-bedrock-worker-node"
    }
  }
}

# Create an Instance Profile for the self-managed nodes
resource "aws_iam_instance_profile" "node_profile" {
  name = "project-bedrock-node-profile-${random_string.suffix.result}"
  role = aws_iam_role.node_role.name
}

# Deploy via a standard Autoscaling Group to bypass Managed Node restrictions
resource "aws_autoscaling_group" "bedrock_nodes" {
  name                = "project-bedrock-worker-nodes-${random_string.suffix.result}"
  desired_capacity    = 1
  max_size            = 1
  min_size            = 1
  vpc_zone_identifier = data.aws_subnets.default.ids

  launch_template {
    id      = aws_launch_template.eks_nodes.id
    version = "$Latest"
  }

  tag {
    key                 = "kubernetes.io/cluster/${aws_eks_cluster.bedrock_cluster.name}"
    value               = "owned"
    propagate_at_launch = true
  }

  depends_on = [
    aws_eks_cluster.bedrock_cluster
  ]
}