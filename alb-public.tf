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


  default_action {
    type = var.default_action_http

    dynamic "redirect" {
      for_each = try([var.default_action_redirect.redirect_response], [])

      content {
        port        = redirect.value.port
        protocol    = redirect.value.protocol
        status_code = redirect.value.status_code
      }
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
  count           = length(var.additional_certificate_arns)
  listener_arn    = aws_lb_listener.public_https.arn
  certificate_arn = var.additional_certificate_arns[count.index]
}