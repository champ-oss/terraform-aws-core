resource "aws_s3_bucket" "this" {
  count         = var.enabled ? 1 : 0
  bucket_prefix = "aws-lb-"
  force_destroy = !var.protect
  tags          = var.tags

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_versioning" "this" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.enabled && var.enable_lifecycle_configuration ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  rule {
    id     = "expiration"
    status = "Enabled"
    expiration {
      days = var.log_retention
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.s3[0].json
}

data "aws_elb_service_account" "this" {
  count = var.enabled ? 1 : 0
}

data "aws_iam_policy_document" "s3" {
  count = var.enabled ? 1 : 0
  statement {
    actions = ["s3:PutObject"]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = [data.aws_elb_service_account.this[0].arn]
    }
  }

  statement {
    actions = ["s3:PutObject"]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
    condition {
      test     = "StringEquals"
      values   = ["bucket-owner-full-control"]
      variable = "s3:x-amz-acl"
    }
  }

  statement {
    actions = ["s3:GetBucketAcl"]
    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]
    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  count                   = var.enabled ? 1 : 0
  bucket                  = aws_s3_bucket.this[0].id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

#Enable Server Access Logging
#Create target bucket for access logs
resource "aws_s3_bucket" "aws_lb_server_access_log_bucket" {
  count  = var.enabled ? 1 : 0
  bucket_prefix = "aws-lb-access-logs-"

  lifecycle {
    prevent_destroy = true
  }
  versioning {
    enabled = true
  }
}

#Enable logging
resource "aws_s3_bucket_logging" "aws_lb_bucket_logging" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.this[0].id
  target_bucket = aws_s3_bucket.aws_lb_server_access_log_bucket[0].id
  target_prefix = "aws-lb-bucket-logs/"
}

#IAM policy to allow logging service to write logs to S3 bucket
data "aws_iam_policy_document" "log_delivery_policy" {
  count  = var.enabled ? 1 : 0
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "${aws_s3_bucket.aws_lb_server_access_log_bucket[0].arn}/*"
    ]
    principals {
      type = "Service"
      identifiers = ["logging.s3.amazonaws.com"]
    }
    condition {
      test = "StringEquals"
      variable = "aws:SourceArn"
      values = [aws_s3_bucket.aws_lb_server_access_log_bucket[0].arn]
    }
  }
}

#Associate the policy with target bucket
resource "aws_s3_bucket_policy" "log_delivery_bucket_policy" {
  count  = var.enabled ? 1 : 0
  bucket = aws_s3_bucket.aws_lb_server_access_log_bucket[0].id
  policy = data.aws_iam_policy_document.log_delivery_policy.json
}