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
  load_balancer_arn = aws_lb.private.arn
  depends_on        = [aws_lb.private] # https://github.com/terraform-providers/terraform-provider-aws/issues/9976
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

resource "aws_lb_listener_certificate" "private" {
  count           = length(var.additional_certificate_arns)
  listener_arn    = aws_lb_listener.private_https.arn
  certificate_arn = var.additional_certificate_arns[count.index]
}
