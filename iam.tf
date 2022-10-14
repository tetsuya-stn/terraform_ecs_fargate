# Cloud9
resource "aws_iam_role" "cloud9" {
  name        = "sbcntr-cloud9-role"
  description = "Allows EC2 instances to call AWS services on your behalf."

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_policy" "access_ecr_policy" {
  name        = "sbcntr-AccessECRRepositoryPolicy"
  description = ""
  policy      = file("./policy_json/access_ecr_policy.json")
}

resource "aws_iam_role_policy_attachment" "cloud9_access_ecr_policy" {
  role       = aws_iam_role.cloud9.name
  policy_arn = aws_iam_policy.access_ecr_policy.arn
}

# CodeDeploy
resource "aws_iam_role" "ecs_codedeploy" {
  name        = "CodeDeployRoleforECS"
  description = "Allows CodeDeploy to read S3 objects, invoke Lambda functions, publish to SNS topics, and update ECS services on your behalf."

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "codedeploy.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_codedeploy_policy" {
  role       = aws_iam_role.ecs_codedeploy.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# ECS
resource "aws_iam_role" "ecs_service" {
  name        = "AWSServiceRoleForECS"
  description = "Role to enable Amazon ECS to manage your cluster."
  path        = "/aws-service-role/ecs.amazonaws.com/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_service_policy" {
  role       = aws_iam_role.ecs_service.name
  policy_arn = "arn:aws:iam::aws:policy/aws-service-role/AmazonECSServiceRolePolicy"
}
