resource "aws_lb" "frontend" {
  name               = "sbcntr-alb-ingress-frontend"
  internal           = false
  load_balancer_type = "application"
  security_groups = [
    local.security_group_id.ingress,
  ]
  subnets = local.subnet_ids.ingress

  tags = {
    Environment = "dev"
  }
}

# サービス稼働用リスナー
resource "aws_lb_listener" "frontend" {
  load_balancer_arn = aws_lb.frontend.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sbcntr_frontend.arn
  }

  lifecycle {
    ignore_changes = [default_action]
  }
}

resource "aws_lb_target_group" "sbcntr_frontend" {
  name        = "sbcntr-tg-frontend"
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
