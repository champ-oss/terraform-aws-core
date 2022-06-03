resource "aws_security_group" "alb" {
  name_prefix = "${var.name}-alb-"
  vpc_id      = var.vpc_id
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "alb_egress_ecs" {
  description              = "ecs"
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = aws_security_group.app.id
}

resource "aws_security_group_rule" "alb_ingress_http" {
  description       = "http"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = concat(["10.0.0.0/8"], var.cidr_blocks)
}

resource "aws_security_group_rule" "alb_ingress_https" {
  description       = "https"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.alb.id
  cidr_blocks       = concat(["10.0.0.0/8"], var.cidr_blocks)
}

resource "aws_security_group" "app" {
  name_prefix = "${var.name}-app-"
  vpc_id      = var.vpc_id
  tags        = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "app_egress_internet" {
  description       = "internet"
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "all"
  security_group_id = aws_security_group.app.id
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "app_ingress_alb" {
  description              = "alb"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "all"
  security_group_id        = aws_security_group.app.id
  source_security_group_id = aws_security_group.alb.id
}
