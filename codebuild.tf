resource "aws_codebuild_project" "sbcntr_backend" {
  name           = "sbcntr-codebuild"
  description    = ""
  badge_enabled  = true
  build_timeout  = "60"
  queued_timeout = "480"
  service_role   = "arn:aws:iam::448346652527:role/service-role/sbcntr-codebuild-role"
  source_version = "refs/heads/main"

  artifacts {
    type = "NO_ARTIFACTS"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-x86_64-standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
  }

  source {
    type            = "CODECOMMIT"
    location        = "https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/sbcntr-backend"
    git_clone_depth = 1

    git_submodules_config {
      fetch_submodules = false
    }
  }
}