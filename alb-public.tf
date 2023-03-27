resource "aws_lb" "public" {
  depends_on         = [aws_s3_bucket.this, aws_s3_bucket_policy.this]
  name_prefix        = "lb-pb-"
  load_balancer_type = var.load_balancer_type
  security_groups    = var.load_balancer_type == "application" ? [aws_security_group.alb.id] : []
  subnets            = var.public_subnet_ids
  tags               = merge(local.tags, var.tags)
  internal           = false

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_listener" "public_http" {
  load_balancer_arn = aws_lb.public.arn
  depends_on        = [aws_lb.public] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
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
  load_balancer_arn = aws_lb.public.arn
  depends_on        = [aws_lb.public] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
  port              = "443"
  protocol          = var.load_balancer_type == "application" ? "HTTPS" : "TCP"
  ssl_policy        = var.load_balancer_type == "application" ? var.ssl_policy : ""
  certificate_arn   = var.load_balancer_type == "application" ? var.certificate_arn : ""

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

resource "aws_lb_listener_certificate" "this" {
  count           = length(var.additional_certificate_arns)
  listener_arn    = aws_lb_listener.public_https.arn
  certificate_arn = var.additional_certificate_arns[count.index]
}