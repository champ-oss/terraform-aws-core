terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.40.0"
    }
  }
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
  count             = var.enabled ? 1 : 0
  source            = "github.com/champ-oss/terraform-aws-acm.git?ref=v1.0.117-6aa9478"
  git               = local.git
  domain_name       = "${local.git}.${data.aws_route53_zone.this.name}"
  create_wildcard   = false
  zone_id           = data.aws_route53_zone.this.zone_id
  enable_validation = true
  enabled           = var.enabled
}

variable "enabled" {
  description = "module enabled"
  type        = bool
  default     = true
}

module "this" {
  source                     = "../../"
  name                       = local.git
  git                        = local.git
  public_subnet_ids          = data.aws_subnets.public.ids
  private_subnet_ids         = data.aws_subnets.private.ids
  vpc_id                     = data.aws_vpcs.this.ids[0]
  certificate_arn            = try(module.acm[0].arn, "")
  enable_container_insights  = false
  enable_deletion_protection = false
  enabled                    = var.enabled
  enable_lb                  = true
  enable_waf                 = true

  # Step 1: stage the ranges. Step 2: run the rule in count mode so nothing is blocked
  # while the <git>-IPAllowList metric shows what "block" would reject.
  # 203.0.113.0/24 is TEST-NET-3 and 198.51.100.42 is TEST-NET-2 (bare IP, normalized to /32).
  waf_ip_allow_list        = ["203.0.113.0/24", "198.51.100.42"]
  waf_ip_allow_list_action = "count"

  # Separate list: ranges that bypass the WAF entirely, including the geo block.
  # Also in count mode, so the rule is exercised without granting a real bypass.
  waf_geo_exempt_ip_list = ["192.0.2.0/24"]
  waf_geo_exempt_action  = "count"
}

# Create a simple ECS service to test Container Insights logging
resource "aws_ecs_task_definition" "this" {
  count  = var.enabled ? 1 : 0
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
  count                 = var.enabled ? 1 : 0
  name                  = local.git
  cluster               = module.this.ecs_cluster_name
  task_definition       = aws_ecs_task_definition.this[0].arn
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
