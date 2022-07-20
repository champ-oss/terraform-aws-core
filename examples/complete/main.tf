provider "aws" {
  region = "us-west-2"
}

locals {
  git = "terraform-aws-core"
  tags = {
    git     = local.git
    cost    = "shared"
    creator = "terraform"
  }
}

data "aws_route53_zone" "this" {
  name = "oss.champtest.net."
}

module "vpc" {
  source                   = "github.com/champ-oss/terraform-aws-vpc.git?ref=v1.0.27-a0de848"
  git                      = local.git
  availability_zones_count = 2
  retention_in_days        = 1
  create_private_subnets   = true
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.68-6f7c12f"
  git               = local.git
  domain_name       = "${local.git}.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
}

module "this" {
  source                    = "../../"
  name                      = local.git
  git                       = local.git
  public_subnet_ids         = module.vpc.public_subnets_ids
  private_subnet_ids        = module.vpc.private_subnets_ids
  vpc_id                    = module.vpc.vpc_id
  certificate_arn           = module.acm.arn
  protect                   = false
  enable_container_insights = true
}

# Create a simple ECS service to test Container Insights logging
resource "aws_ecs_task_definition" "this" {
  family = local.git
  container_definitions = jsonencode([
    {
      name      = "this"
      image     = "testcontainers/helloworld"
      essential = true
    }
  ])
  execution_role_arn       = module.this.execution_ecs_role_arn
  task_role_arn            = module.this.execution_ecs_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  tags                     = local.tags
}

resource "aws_ecs_service" "this" {
  name                  = local.git
  cluster               = module.this.ecs_cluster_name
  task_definition       = aws_ecs_task_definition.this.arn
  desired_count         = 1
  launch_type           = "FARGATE"
  propagate_tags        = "SERVICE"
  wait_for_steady_state = false
  tags                  = local.tags

  network_configuration {
    security_groups = [module.this.ecs_app_security_group]
    subnets         = module.vpc.private_subnets_ids
  }
}
