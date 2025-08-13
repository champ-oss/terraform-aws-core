resource "aws_lb" "public" {
  count           = var.enabled && !var.paused ? 1 : 0
  depends_on      = [aws_s3_bucket.this, aws_s3_bucket_policy.this]
  name_prefix     = "lb-pb-"
  security_groups = [aws_security_group.alb[0].id]
  subnets         = var.public_subnet_ids
  tags            = merge(local.tags, var.tags)
  internal        = false

  access_logs {
    bucket  = aws_s3_bucket.this[0].bucket
    enabled = true
  }

  connection_logs {
    bucket  = aws_s3_bucket.this[0].bucket
    enabled = var.enable_connection_logs
    prefix  = var.connection_logs_prefix
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "public_http" {
  count             = var.enabled && !var.paused ? 1 : 0
  load_balancer_arn = aws_lb.public[0].arn
  depends_on        = [aws_lb.public] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
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

resource "aws_lb_listener" "public_https" {
  count             = var.enabled && !var.paused ? 1 : 0
  load_balancer_arn = aws_lb.public[0].arn
  depends_on        = [aws_lb.public] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
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

resource "aws_lb_listener_certificate" "this" {
  count           = (var.enabled && !var.paused) && length(var.additional_certificate_arns) > 0 ? length(var.additional_certificate_arns) : 0
  listener_arn    = aws_lb_listener.public_https[0].arn
  certificate_arn = var.additional_certificate_arns[count.index]
}
