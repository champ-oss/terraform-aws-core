moved {
  from = aws_lb.private
  to   = aws_lb.private[0]
}

moved {
  from = aws_lb_listener.private_http
  to   = aws_lb_listener.private_http[0]
}

moved {
  from = aws_lb_listener.private_https
  to   = aws_lb_listener.private_https[0]
}

moved {
  from = aws_lb_listener_certificate.private
  to   = aws_lb_listener_certificate.private[0]
}

moved {
  from = aws_lb.public
  to   = aws_lb.public[0]
}

moved {
  from = aws_lb_listener.public_http
  to   = aws_lb_listener.public_http[0]
}

moved {
  from = aws_lb_listener.public_https
  to   = aws_lb_listener.public_https[0]
}

moved {
  from = aws_lb_listener_certificate.this
  to   = aws_lb_listener_certificate.this[0]
}

moved {
  from = aws_athena_database.this
  to   = aws_athena_database.this[0]
}

moved {
  from = aws_athena_named_query.this
  to   = aws_athena_named_query.this[0]
}

moved {
  from = aws_ecs_cluster.this
  to   = aws_ecs_cluster.this[0]
}

moved {
  from = aws_ecs_cluster_capacity_providers.this
  to   = aws_ecs_cluster_capacity_providers.this[0]
}

moved {
  from = time_sleep.wait_container_insight_logs
  to   = time_sleep.wait_container_insight_logs[0]
}

moved {
  from = aws_cloudwatch_log_group.this
  to   = aws_cloudwatch_log_group.this[0]
}

moved {
  from = aws_iam_policy.ssm_policy
  to   = aws_iam_policy.ssm_policy[0]
}

moved {
  from = aws_iam_role_policy_attachment.ssm_policy
  to   = aws_iam_role_policy_attachment.ssm_policy[0]
}

moved {
  from = aws_iam_role.this
  to   = aws_iam_role.this[0]
}

moved {
  from = aws_iam_role_policy_attachment.ecs
  to   = aws_iam_role_policy_attachment.ecs[0]
}

moved {
  from = aws_iam_role_policy_attachment.ses
  to   = aws_iam_role_policy_attachment.ses[0]
}

moved {
  from = aws_iam_role_policy_attachment.s3
  to   = aws_iam_role_policy_attachment.s3[0]
}

moved {
  from = aws_iam_role_policy_attachment.lambda
  to   = aws_iam_role_policy_attachment.lambda[0]
}

moved {
  from = aws_iam_role_policy_attachment.textract
  to   = aws_iam_role_policy_attachment.textract[0]
}

moved {
  from = aws_iam_role_policy_attachment.ssm
  to   = aws_iam_role_policy_attachment.ssm[0]
}

moved {
  from = aws_iam_role_policy_attachment.ecr
  to   = aws_iam_role_policy_attachment.ecr[0]
}

moved {
  from = data.aws_region.this
  to   = data.aws_region.this[0]
}

moved {
  from = data.aws_caller_identity.this
  to   = data.aws_caller_identity.this[0]
}

moved {
  from = aws_s3_bucket.this
  to   = aws_s3_bucket.this[0]
}

moved {
  from = aws_s3_bucket_ownership_controls.this
  to   = aws_s3_bucket_ownership_controls.this[0]
}

moved {
  from = aws_s3_bucket_server_side_encryption_configuration.this
  to   = aws_s3_bucket_server_side_encryption_configuration.this[0]
}

moved {
  from = aws_s3_bucket_versioning.this
  to   = aws_s3_bucket_versioning.this[0]
}

moved {
  from = aws_s3_bucket_lifecycle_configuration.this
  to   = aws_s3_bucket_lifecycle_configuration.this[0]
}

moved {
  from = aws_s3_bucket_policy.this
  to   = aws_s3_bucket_policy.this[0]
}

moved {
  from = data.aws_elb_service_account.this
  to   = data.aws_elb_service_account.this[0]
}

moved {
  from = data.aws_iam_policy_document.s3
  to   = data.aws_iam_policy_document.s3[0]
}
moved {
  from = aws_s3_bucket_public_access_block.this
  to   = aws_s3_bucket_public_access_block.this[0]
}

moved {
  from = aws_security_group.alb
  to   = aws_security_group.alb[0]
}

moved {
  from = aws_security_group_rule.alb_egress_ecs
  to   = aws_security_group_rule.alb_egress_ecs[0]
}

moved {
  from = aws_security_group_rule.alb_ingress_http
  to   = aws_security_group_rule.alb_ingress_http[0]
}

moved {
  from = aws_security_group_rule.alb_ingress_https
  to   = aws_security_group_rule.alb_ingress_https[0]
}

moved {
  from = aws_security_group_rule.app_self_rule
  to   = aws_security_group_rule.app_self_rule[0]
}

moved {
  from = aws_security_group_rule.app_egress_internet
  to   = aws_security_group_rule.app_egress_internet[0]
}

moved {
  from = aws_security_group.app
  to   = aws_security_group.app[0]
}

moved {
  from = aws_security_group_rule.app_ingress_alb
  to   = aws_security_group_rule.app_ingress_alb[0]
}
