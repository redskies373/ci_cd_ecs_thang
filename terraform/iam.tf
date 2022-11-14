resource "aws_iam_policy" "gha-self-hosted-runner-policy" {
  name        = "gha-self-hosted-runner-policy"
  path        = "/"
  description = "gha-self-hosted-runner-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
            #"ec2:RunInstances",
            #"ec2:TerminateInstances",
            #"ec2:DescribeInstances",
            #"ec2:DescribeInstanceStatus"
            "*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "gha_attachment" {
  name       = "gha_attachment"
  users      = [var.gha_user]
  policy_arn = aws_iam_policy.gha-self-hosted-runner-policy.arn
}

resource "aws_iam_access_key" "gha-access-key" {
  user  = var.gha_user
}