resource "aws_ecs_task_definition" "backend" {
  family                   = "sbcntr-backend-tf"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "arn:aws:iam::448346652527:role/ecsTaskExecutionRole"
  task_role_arn            = null
  skip_destroy             = true

  container_definitions = file("./ecs_task_json/backend.json")
}

resource "aws_ecs_task_definition" "frontend" {
  family                   = "sbcntr-frontend-def"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = "arn:aws:iam::448346652527:role/ecsTaskExecutionRole"
  task_role_arn            = null
  skip_destroy             = true

  container_definitions = file("./ecs_task_json/frontend.json")
}
