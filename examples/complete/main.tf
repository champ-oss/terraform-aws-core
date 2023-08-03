terraform {
  backend "s3" {}
}

provider "aws" {
  region = "us-east-2"
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

data "aws_vpcs" "this" {
  tags = {
    purpose = "vega"
  }
}

data "aws_subnets" "private" {
  tags = {
    purpose = "vega"
    Type    = "Private"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

data "aws_subnets" "public" {
  tags = {
    purpose = "vega"
    Type    = "Public"
  }

  filter {
    name   = "vpc-id"
    values = [data.aws_vpcs.this.ids[0]]
  }
}

module "acm" {
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.114-1c756c3"
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
  public_subnet_ids         = data.aws_subnets.public.ids
  private_subnet_ids        = data.aws_subnets.private.ids
  vpc_id                    = data.aws_vpcs.this.ids[0]
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
    subnets         = data.aws_subnets.private.ids
  }
}
