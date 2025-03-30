

# Create an IAM Role with a trust policy allowing EC2 to assume the role
resource "aws_iam_role" "ec2_role" {
  name               = "Terraform-admin-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Define IAM policy WITH THESE AmazonEKSClusterPolicy, AmazonEKSServicePolicy, AmazonEC2ContainerRegistryReadOnly, AmazonVPCFullAccess, IAMFullAccess, AutoScalingFullAccess (example: allowing EC2 to interact with S3)
 #Admin access policy
resource "aws_iam_role_policy_attachment" "adminAccessPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
  role       = aws_iam_role.ec2_role.name
}

/*
# Attach AmazonEKSClusterPolicy to the IAM Role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.ec2_role.name
}

# Attach AmazonEKSServicePolicy to the IAM Role
resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.ec2_role.name
}

# Attach AmazonEC2ContainerRegistryReadOnly to the IAM Role
resource "aws_iam_role_policy_attachment" "ecr_readonly_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.ec2_role.name
}

# Attach AmazonVPCFullAccess to the IAM Role
resource "aws_iam_role_policy_attachment" "vpc_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
  role       = aws_iam_role.ec2_role.name
}

# Attach IAMFullAccess to the IAM Role
resource "aws_iam_role_policy_attachment" "iam_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/IAMFullAccess"
  role       = aws_iam_role.ec2_role.name
}

# Attach AutoScalingFullAccess to the IAM Role
resource "aws_iam_role_policy_attachment" "autoscaling_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.ec2_role.name
}
*/

# Create an IAM instance profile to attach the IAM role to the EC2 instance
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2InstanceProfileWithEKSPermissions"
  role = aws_iam_role.ec2_role.name
}
