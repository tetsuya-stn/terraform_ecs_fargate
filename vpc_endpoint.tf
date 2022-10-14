resource "aws_vpc_endpoint" "s3_for_docekr_image" {
  vpc_id            = local.vpc_id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    local.route_table_id.sbcntr_route_app,
  ]

  tags = {
    Environment = "dev"
    Name        = "sbcntr-vpce-s3"
  }
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = local.subnet_ids.egress

  security_group_ids = [
    local.security_group_id.egress,
  ]

  tags = {
    Environment = "dev"
    Name        = "sbcntr-vpce-ecr-api"
  }
}

resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = local.subnet_ids.egress

  security_group_ids = [
    local.security_group_id.egress,
  ]

  tags = {
    Environment = "dev"
    Name        = "sbcntr-vpce-ecr-dkr"
  }
}

resource "aws_vpc_endpoint" "cloudwatch_logs" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.logs"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = local.subnet_ids.egress

  security_group_ids = [
    local.security_group_id.egress,
  ]

  tags = {
    Environment = "dev"
    Name        = "sbcntr-vpce-logs"
  }
}

resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id              = local.vpc_id
  service_name        = "com.amazonaws.ap-northeast-1.secretsmanager"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = local.subnet_ids.egress

  security_group_ids = [
    local.security_group_id.egress,
  ]

  tags = {
    Environment = "dev"
    Name        = "sbcntr-vpce-secrets"
  }
}