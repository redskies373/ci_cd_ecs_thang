resource "github_actions_secret" "gha_secret_id" {
  repository       = var.gha_repo
  secret_name      = "GHA_RUNNER_ACCESS_ID"
  plaintext_value  = aws_iam_access_key.gha-access-key.id
}

resource "github_actions_secret" "gha_secret_key" {
  repository       = var.gha_repo
  secret_name      = "GHA_RUNNER_ACCESS_KEY"
  plaintext_value  = aws_iam_access_key.gha-access-key.secret
}

resource "github_actions_secret" "gha_runner_subnet_id" {
  repository       = var.gha_repo
  secret_name      = "GHA_RUNNER_SUBNET_ID"
  plaintext_value  = var.subnets[0]
}

resource "github_actions_secret" "gha_runner_sg" {
  repository       = var.gha_repo
  secret_name      = "GHA_RUNNER_SG"
  plaintext_value  = aws_security_group.github-runner-sg.name
}