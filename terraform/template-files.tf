data "template_file" ecs_task_configuration_def {
  template = file("${path.module}/templates/${var.task_def_file_name}.tpl")
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
    src_hash = file("${path.module}/templates/${var.task_def_file_name}.tpl")
  }
  depends_on = [data.template_file.ecs_task_configuration_def]

  provisioner "local-exec" {
    command = format(
      "cat <<\"EOF\" > \"%s\"\n%s\nEOF",
      "../${var.task_def_file_name}",
      data.template_file.ecs_task_configuration_def.rendered
    )
  }
}