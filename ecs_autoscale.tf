resource "aws_appautoscaling_target" "sbcntr_backend" {
  max_capacity       = 2
  min_capacity       = 0
  resource_id        = "service/${aws_ecs_cluster.backend.name}/${aws_ecs_service.backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  role_arn           = "arn:aws:iam::448346652527:role/aws-service-role/ecs.application-autoscaling.amazonaws.com/AWSServiceRoleForApplicationAutoScaling_ECSService"
}

resource "aws_appautoscaling_policy" "sbcntr_backend" {
  name               = "sbcntr-ecs-scalingPolicy"
  service_namespace  = aws_appautoscaling_target.sbcntr_backend.service_namespace
  resource_id        = aws_appautoscaling_target.sbcntr_backend.resource_id
  scalable_dimension = aws_appautoscaling_target.sbcntr_backend.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    # CPU使用率 50 を維持する感じ
    target_value       = 70
    scale_out_cooldown = 300
    scale_in_cooldown  = 300
  }

  depends_on = [aws_appautoscaling_target.sbcntr_backend]
}
