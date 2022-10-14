resource "aws_lb" "frontend_to_backend" {
  name               = "sbcntr-alb-internal"
  internal           = true
  load_balancer_type = "application"
  security_groups = [
    local.security_group_id.internal,
  ]
  subnets = local.subnet_ids.container

  tags = {
    Environment = "dev"
  }
}

# サービス稼働用リスナー
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.frontend_to_backend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sbcntr_backend_blue.arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}

# テスト用リスナー
resource "aws_lb_listener" "backend_for_test" {
  load_balancer_arn = aws_lb.frontend_to_backend.arn
  port              = "10080"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sbcntr_backend_green.arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}

resource "aws_lb_target_group" "sbcntr_backend_blue" {
  name        = "sbcntr-tg-sbcntrdemo-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"

  health_check {
    path                = "/healthcheck"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    unhealthy_threshold = 2
  }
}

resource "aws_lb_target_group" "sbcntr_backend_green" {
  name        = "sbcntr-tg-sbcntrdemo-green"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = local.vpc_id
  target_type = "ip"

  health_check {
    path                = "/healthcheck"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    unhealthy_threshold = 2
  }
}
