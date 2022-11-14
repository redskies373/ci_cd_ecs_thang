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

resource "aws_iam_policy_attachment" "gha_role_attachment" {
  name       = "gha_role_attachment"
  roles      = ["gha_runner_role"]
  policy_arn = aws_iam_policy.gha-self-hosted-runner-policy.arn
}