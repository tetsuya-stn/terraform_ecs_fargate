#resource "aws_codepipeline" "sbcntr_backend" {
#  name     = "sbcntr-pipeline"
#  role_arn = "arn:aws:iam::448346652527:role/service-role/sbcntr-pipeline-role"
#
#  artifact_store {
#    location = "codepipeline-ap-northeast-1-277846286139"
#    type     = "S3"
#    region   = "ap-northeast-1"
#  }
#
#  stage {
#    name = "Source"
#
#    action {
#      name             = "Source"
#      category         = "Source"
#      owner            = "AWS"
#      provider         = "CodeStarSourceConnection"
#      version          = "1"
#      output_artifacts = ["source_output"]
#
#      configuration = {
#        ConnectionArn    = aws_codestarconnections_connection.example.arn
#        FullRepositoryId = "my-organization/example"
#        BranchName       = "main"
#      }
#    }
#  }
#
#  stage {
#    name = "Build"
#
#    action {
#      name             = "Build"
#      category         = "Build"
#      owner            = "AWS"
#      provider         = "CodeBuild"
#      input_artifacts  = ["source_output"]
#      output_artifacts = ["build_output"]
#      version          = "1"
#
#      configuration = {
#        ProjectName = "test"
#      }
#    }
#  }
#
#  stage {
#    name = "Deploy"
#
#    action {
#      name            = "Deploy"
#      category        = "Deploy"
#      owner           = "AWS"
#      provider        = "CloudFormation"
#      input_artifacts = ["build_output"]
#      version         = "1"
#
#      configuration = {
#        ActionMode     = "REPLACE_ON_FAILURE"
#        Capabilities   = "CAPABILITY_AUTO_EXPAND,CAPABILITY_IAM"
#        OutputFileName = "CreateStackOutput.json"
#        StackName      = "MyStack"
#        TemplatePath   = "build_output::sam-templated.yaml"
#      }
#    }
#  }
#}
