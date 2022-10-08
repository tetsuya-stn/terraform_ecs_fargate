resource "aws_iam_role" "cloud9" {
  name = "sbcntr-cloud9-role"
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
