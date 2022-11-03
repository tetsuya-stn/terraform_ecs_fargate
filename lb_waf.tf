resource "aws_wafv2_web_acl" "sbcntr_frontend" {
  name  = "sbcntr-waf-webacl"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "sbcntr-waf-webacl"
    sampled_requests_enabled   = true
  }

  dynamic "rule" {
    for_each = local.waf_rule

    content {
      name     = "AWS-${rule.key}"
      priority = rule.value

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          name        = rule.key
          vendor_name = "AWS"
        }
      }
      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "AWS-${rule.key}"
        sampled_requests_enabled   = true
      }
    }
  }
}

resource "aws_wafv2_web_acl_association" "sbcntr_frontend" {
  resource_arn = aws_lb.frontend.arn
  web_acl_arn  = aws_wafv2_web_acl.sbcntr_frontend.arn
}