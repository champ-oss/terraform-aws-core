resource "aws_lb" "private" {
  count                       = var.enabled && !var.paused ? 1 : 0
  name_prefix                 = "lb-pv-"
  security_groups             = [aws_security_group.alb[0].id]
  subnets                     = var.private_subnet_ids
  tags                        = merge(local.tags, var.tags)
  internal                    = true
  enable_deletion_protection  = var.enable_deletion_protection

  dynamic "access_logs" {
  for_each = var.central_audit_bucket != null ? [1] : []

  content {
    enabled = true
    bucket  = var.central_audit_bucket
  }
}

  dynamic "connection_logs" {
  for_each = var.central_audit_bucket != null ? [1] : []

  content {
    enabled = true
    bucket  = var.central_audit_bucket
    prefix  = var.connection_logs_prefix
  }
}

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "private_http" {
  count             = var.enabled && !var.paused ? 1 : 0
  load_balancer_arn = aws_lb.private[0].arn
  depends_on        = [aws_lb.private] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "private_https" {
  count             = var.enabled && !var.paused ? 1 : 0
  load_balancer_arn = aws_lb.private[0].arn
  depends_on        = [aws_lb.private] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "No valid routing rule"
      status_code  = "400"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_certificate" "private" {
  count           = (var.enabled && !var.paused) && length(var.additional_certificate_arns) > 0 ? length(var.additional_certificate_arns) : 0
  listener_arn    = aws_lb_listener.private_https[0].arn
  certificate_arn = var.additional_certificate_arns[count.index]
}
