resource "aws_iam_role" "this" {
  count              = var.enabled && !var.paused ? 1 : 0
  name_prefix        = var.git
  assume_role_policy = data.aws_iam_policy_document.this[0].json
  tags               = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "this" {
  count = var.enabled && !var.paused ? 1 : 0
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
      "ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ssm_policy" {
  count = var.enabled && !var.paused ? 1 : 0
  statement {
    actions = [
      "secretsmanager:GetSecretValue",
      "kms:Decrypt",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ssm_policy" {
  count       = var.enabled && !var.paused ? 1 : 0
  name_prefix = "${var.git}-ssm-policy"
  policy      = data.aws_iam_policy_document.ssm_policy[0].json
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  count      = var.enabled && !var.paused ? 1 : 0
  policy_arn = aws_iam_policy.ssm_policy[0].arn
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "ecs" {
  count      = var.enabled && !var.paused ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.this[0].name
}

moved {
  from = data.aws_iam_policy_document.this
  to   = data.aws_iam_policy_document.this[0]
}

moved {
  from = aws_iam_role_policy_attachment.ssm_policy
  to   = aws_iam_role_policy_attachment.ssm_policy[0]
}

resource "aws_iam_role_policy_attachment" "ssm" {
  count      = var.enabled && !var.paused ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "ecr" {
  count      = var.enabled && !var.paused ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "ses" {
  count      = var.enabled && !var.paused ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "s3" {
  count      = var.enabled && !var.paused ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "lambda" {
  count      = var.enabled && !var.paused ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  role       = aws_iam_role.this[0].name
}

resource "aws_iam_role_policy_attachment" "textract" {
  count      = var.enabled && !var.paused ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonTextractFullAccess"
  role       = aws_iam_role.this[0].name
}

