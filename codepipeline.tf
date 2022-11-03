resource "aws_codepipeline" "sbcntr_backend" {
  name     = "sbcntr-pipeline"
  role_arn = "arn:aws:iam::448346652527:role/service-role/sbcntr-pipeline-role"

  artifact_store {
    location = "codepipeline-ap-northeast-1-277846286139"
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      category         = "Source"
      configuration    = {
        "BranchName"           = "main"
        "OutputArtifactFormat" = "CODE_ZIP"
        "PollForSourceChanges" = "false"
        "RepositoryName"       = "sbcntr-backend"
      }
      input_artifacts  = []
      name             = "Source"
      namespace        = "SourceVariables"
      output_artifacts = [
        "SourceArtifact",
      ]
      owner            = "AWS"
      provider         = "CodeCommit"
      region           = "ap-northeast-1"
      run_order        = 1
      version          = "1"
    }
  }

  stage {
    name = "Build"

    action {
      category         = "Build"
      configuration    = {
        "ProjectName" = "sbcntr-codebuild"
      }
      input_artifacts  = [
        "SourceArtifact",
      ]
      name             = "Build"
      namespace        = "BuildVariables"
      output_artifacts = [
        "BuildArtifact",
      ]
      owner            = "AWS"
      provider         = "CodeBuild"
      region           = "ap-northeast-1"
      run_order        = 1
      version          = "1"
    }
  }

  stage {
    name = "Deploy"

    action {
      category         = "Deploy"
      configuration    = {
        "AppSpecTemplateArtifact"        = "SourceArtifact"
        "ApplicationName"                = "AppECS-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
        "DeploymentGroupName"            = "DgpECS-sbcntr-ecs-backend-cluster-sbcntr-ecs-backend-service"
        "Image1ArtifactName"             = "BuildArtifact"
        "Image1ContainerName"            = "IMAGE1_NAME"
        "TaskDefinitionTemplateArtifact" = "SourceArtifact"
      }
      input_artifacts  = [
        "BuildArtifact",
        "SourceArtifact",
      ]
      name             = "Deploy"
      namespace        = "DeployVariables"
      output_artifacts = []
      owner            = "AWS"
      provider         = "CodeDeployToECS"
      region           = "ap-northeast-1"
      run_order        = 1
      version          = "1"
    }
  }
}
