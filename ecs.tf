resource "aws_ecs_cluster" "backend" {
  name = "sbcntr-ecs-backend-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "backend" {
  name             = "sbcntr-ecs-backend-service"
  cluster          = aws_ecs_cluster.backend.id
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  task_definition  = aws_ecs_task_definition.backend.arn
  desired_count    = 1

  health_check_grace_period_seconds = 120

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.sbcntr_backend_blue.arn
    container_name   = "app"
    container_port   = 80
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [local.security_group_id.container]
    subnets          = local.subnet_ids.container
  }

  service_registries {
    registry_arn = "arn:aws:servicediscovery:ap-northeast-1:448346652527:service/srv-4yfsyf6kh63wkeru"
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}

resource "aws_ecs_service" "frontend" {
  name             = "sbcntr-ecs-frontend-service"
  cluster          = aws_ecs_cluster.backend.id
  launch_type      = "FARGATE"
  platform_version = "1.4.0"
  task_definition  = aws_ecs_task_definition.frontend.arn
  desired_count    = 1

  health_check_grace_period_seconds = 120

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.sbcntr_frontend.arn
    container_name   = "app"
    container_port   = 80
  }

  network_configuration {
    assign_public_ip = false
    security_groups  = [local.security_group_id.front_container]
    subnets          = local.subnet_ids.container
  }

  lifecycle {
    ignore_changes = [task_definition, load_balancer]
  }
}
