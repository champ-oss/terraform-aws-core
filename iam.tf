resource "aws_iam_role" "this" {
  name_prefix        = var.git
  assume_role_policy = data.aws_iam_policy_document.this.json
  tags               = local.tags

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "this" {
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
  statement {
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ssm_policy" {
  name_prefix = "${var.git}-ssm-policy"
  policy      = data.aws_iam_policy_document.ssm_policy.json
}

resource "aws_iam_role_policy_attachment" "ssm_policy" {
  policy_arn = aws_iam_policy.ssm_policy.arn
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "ecs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "ssm" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "ecr" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "ses" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "s3" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "lambda" {
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
  role       = aws_iam_role.this.name
}

resource "aws_iam_role_policy_attachment" "textract" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonTextractFullAccess"
  role       = aws_iam_role.this.name
}

