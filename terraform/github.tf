resource "github_actions_secret" "gha_runner_sg" {
  repository       = var.gha_repo
  secret_name      = "GHA_RUNNER_SG"
  plaintext_value  = tostring(aws_security_group.github-runner-sg.id)
}

resource "github_actions_secret" "gha_runner_subnet" {
  repository       = var.gha_repo
  secret_name      = "GHA_RUNNER_SUBNET"
  plaintext_value  = tostring(var.subnets[0])
}