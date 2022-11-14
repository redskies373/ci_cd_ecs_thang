data "template_file" ecs_task_configuration_def {
  template = file("${path.module}/templates/task-definition.json.tpl")
  vars = {
    ecr_registry                = local.ecr_registry
    ecr_repo                    = aws_ecr_repository.github-actions-repo.name
    container_port              = var.container_port
    container_cpu               = var.container_cpu
    container_memory            = var.container_memory
    execution_role              = var.task_role_arn
  }
}

resource "null_resource" "ecs_task_def_render_template" {
  triggers = {
    src_hash = file("${path.module}/templates/task-definition.json.tpl")
  }
  depends_on = [data.template_file.ecs_task_configuration_def]

  provisioner "local-exec" {
    #command = <<EOF
#tee ${path.module}/task-definition.json <<ENDF
#${data.template_file.jenkins_configuration_def.rendered}
#EOF
    command = format(
      "cat <<\"EOF\" > \"%s\"\n%s\nEOF",
      "../task-definition.json",
      data.template_file.ecs_task_configuration_def.rendered
    )
  }
}