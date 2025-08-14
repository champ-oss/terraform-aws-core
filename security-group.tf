resource "aws_security_group" "alb" {
  count       = var.enabled ? 1 : 0
  name_prefix = "${var.name}-alb-"
  vpc_id      = var.vpc_id
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb_egress_ecs" {
  count                    = length(aws_security_group.alb) > 0 ? 1 : 0
  description              = "ecs"
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  security_group_id        = aws_security_group.alb[0].id
  source_security_group_id = aws_security_group.app[0].id
}

resource "aws_security_group_rule" "alb_ingress_http" {
  count             = length(aws_security_group.alb) > 0 ? 1 : 0
  description       = "http"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb[0].id
  cidr_blocks       = concat(["10.0.0.0/8"], var.cidr_blocks)
}

resource "aws_security_group_rule" "alb_ingress_https" {
  count             = length(aws_security_group.alb) > 0 ? 1 : 0
  description       = "https"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb[0].id
  cidr_blocks       = concat(["10.0.0.0/8"], var.cidr_blocks)
}

resource "aws_security_group" "app" {
  count       = var.enabled ? 1 : 0
  name_prefix = "${var.name}-app-"
  vpc_id      = var.vpc_id
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "app_egress_internet" {
  count             = length(aws_security_group.app) > 0 ? 1 : 0
  description       = "internet"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  security_group_id = aws_security_group.app[0].id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_ingress_alb" {
  count                    = length(aws_security_group.app) > 0 ? 1 : 0
  description              = "alb"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  security_group_id        = aws_security_group.app[0].id
  source_security_group_id = aws_security_group.alb[0].id
}

resource "aws_security_group_rule" "app_self_rule" {
  count             = length(aws_security_group.app) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  self              = true
  security_group_id = aws_security_group.app[0].id
}
