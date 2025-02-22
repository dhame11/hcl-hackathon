resource "aws_ecs_cluster" "hackathon-ecs" {
  name = "demo-cluster"
}

resource "aws_ecs_cluster_capacity_providers" "hackathon-ecs" {
  cluster_name = aws_ecs_cluster.hackathon-ecs.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}
resource "aws_ecs_task_definition" "service" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "patient-service"
      image     = "patient-service:v1"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 80
        }
      ]
    },
    {
      name      = "appointment-service"
      image     = "appointment-service:v1"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 3001
          hostPort      = 443
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

