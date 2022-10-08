terraform {
  backend "s3" {
    bucket = "terraform-one2stone"
    key    = "ecs_fargate"
    region = "ap-northeast-1"
  }
}