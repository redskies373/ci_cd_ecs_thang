resource "aws_ecr_repository" "github-actions-repo" {
  name                  = "github-actions"
  image_tag_mutability  = "MUTABLE"
  force_delete          = "true"
  encryption_configuration {
    encryption_type     = "KMS"
  }
  image_scanning_configuration {
    scan_on_push        = "true"
  }
}

resource "aws_ecs_cluster" "github-runner-cluster" {
  name = "github-actions-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_task_definition" "github-runner-td" {
    family                      = "github-actions-task-definition"
    requires_compatibilities    = ["FARGATE"]
    network_mode                = "awsvpc"
    cpu                         = var.container_cpu
    memory                      = var.container_memory
    execution_role_arn          = var.task_role_arn
    task_role_arn               = var.task_role_arn
    container_definitions       = jsonencode([
    {
        name                    = aws_ecr_repository.github-actions-repo.name
        image                   = aws_ecr_repository.github-actions-repo.name
        cpu                     = var.container_cpu
        memory                  = var.container_memory
        essential               = true
        portMappings            = [
        {
            containerPort = var.container_port
            hostPort      = var.container_port
        }]
    }])
    
    runtime_platform {
        operating_system_family = "LINUX"
    }    
}

resource "aws_ecs_service" "github-actions-service" {
  name            = "github-actions-service"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.github-runner-cluster.id
  task_definition = aws_ecs_task_definition.github-runner-td.arn
  desired_count   = 1
  
  network_configuration {
    subnets             = var.subnets
    security_groups     = [aws_security_group.github-actions-sg.id]
    assign_public_ip    = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.github-actions-tg.arn
    container_name   = "github-actions"
    container_port   = var.container_port
  }
}