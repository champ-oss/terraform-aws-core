data "aws_caller_identity" "this" {
  count = var.enabled ? 1 : 0
}

data "aws_region" "this" {
  count = var.enabled ? 1 : 0
}
