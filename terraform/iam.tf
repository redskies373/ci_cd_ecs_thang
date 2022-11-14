resource "aws_iam_policy" "gha-self-hosted-runner-policy" {
  name        = "gha-self-hosted-runner-policy"
  path        = "/"
  description = "gha-self-hosted-runner-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ecr:DescribeImages",
          "ecr:DescribeRepositories",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart",
          "application-autoscaling:Describe*",
          "application-autoscaling:PutScalingPolicy",
          "application-autoscaling:RegisterScalableTarget",
          "cloudwatch:DescribeAlarms",
          "cloudwatch:PutMetricAlarm",
          "ecs:List*",
          "ecs:Describe*",
          "ecs:CreateService",
          "elasticloadbalancing:Describe*",
          "iam:AttachRolePolicy",
          "iam:CreateRole",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:GetRole",
          "iam:ListAttachedRolePolicies",
          "iam:ListRoles",
          "iam:ListGroups",
          "iam:ListUsers"            
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