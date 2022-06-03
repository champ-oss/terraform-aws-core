resource "aws_lb" "public" {
  depends_on      = [aws_s3_bucket.this, aws_s3_bucket_policy.this]
  name_prefix     = "lb-pb-"
  security_groups = [aws_security_group.alb.id]
  subnets         = var.public_subnet_ids
  tags            = merge(local.tags, var.tags)
  internal        = false

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
  load_balancer_arn = aws_lb.public.arn
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
  count           = length(var.additional_certificate_arns)
  listener_arn    = aws_lb_listener.public_https.arn
  certificate_arn = var.additional_certificate_arns[count.index]
}