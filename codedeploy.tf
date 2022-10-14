resource "aws_codedeploy_app" "backend" {
  compute_platform = "ECS"
  name             = "AppECS-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
}

resource "aws_codedeploy_deployment_group" "backend" {
  app_name               = aws_codedeploy_app.backend.name
  deployment_group_name  = "DgpECS-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  service_role_arn       = aws_iam_role.ecs_codedeploy.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 10
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 60
    }
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.backend.name
    service_name = aws_ecs_service.backend.name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [aws_lb_listener.backend.arn]
      }

      test_traffic_route {
        listener_arns = [aws_lb_listener.backend_for_test.arn]
      }

      target_group {
        name = aws_lb_target_group.sbcntr_backend_blue.name
      }

      target_group {
        name = aws_lb_target_group.sbcntr_backend_green.name
      }
    }
  }
}

