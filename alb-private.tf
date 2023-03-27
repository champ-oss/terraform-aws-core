resource "aws_lb" "private" {
  depends_on      = [aws_s3_bucket.this, aws_s3_bucket_policy.this]
  name_prefix     = "lb-pv-"
  security_groups = [aws_security_group.alb.id]
  subnets         = var.private_subnet_ids
  tags            = merge(local.tags, var.tags)
  internal        = true

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "private_http" {
  load_balancer_arn = aws_lb.private.arn
  depends_on        = [aws_lb.private] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
  port              = "80"
  protocol          = var.load_balancer_type == "application" ? "HTTP" : "TCP"

  dynamic "default_action" {
    for_each = try([var.default_action_redirect], [])

    content {
      type = "redirect"

      redirect {
        port        = var.redirect_port
        protocol    = var.redirect_protocol
        status_code = var.redirect_status_code
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "private_https" {
  load_balancer_arn = aws_lb.private.arn
  depends_on        = [aws_lb.private] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
  port              = "443"
  protocol          = var.load_balancer_type == "application" ? "HTTPS" : "TCP"
  ssl_policy        = var.load_balancer_type == "application" ? var.ssl_policy : ""
  certificate_arn   = var.certificate_arn

  dynamic "default_action" {
    for_each = try([var.default_action_fixed_response], [])

    content {
      type = "fixed-response"

      fixed_response {
        content_type = var.fixed_response_content_type
        message_body = var.fixed_response_message_body
        status_code  = var.fixed_response_status_code
      }
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener_certificate" "private" {
  count           = length(var.additional_certificate_arns)
  listener_arn    = aws_lb_listener.private_https.arn
  certificate_arn = var.additional_certificate_arns[count.index]
}
