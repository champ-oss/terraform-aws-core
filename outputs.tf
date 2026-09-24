output "ecs_cluster_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster#name"
  value       = var.enabled ? aws_ecs_cluster.this[0].name : ""
}

output "ecs_app_security_group" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#id"
  value       = var.enabled ? aws_security_group.app[0].id : ""
}

output "execution_ecs_role_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#arn"
  value       = var.enabled ? aws_iam_role.this[0].arn : ""
}

output "execution_ecs_role_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#name"
  value       = var.enabled ? aws_iam_role.this[0].name : ""
}

output "lb_private_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb.private[0].arn : ""
}

output "lb_public_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb.public[0].arn : ""
}

output "lb_private_listener_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb_listener.private_https[0].arn : ""
}

output "lb_public_listener_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb_listener.public_https[0].arn : ""
}

output "lb_public_dns_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb.public[0].dns_name : ""
}

output "lb_private_dns_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb.private[0].dns_name : ""
}

output "lb_public_zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb.public[0].zone_id : ""
}

output "lb_private_zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb.private[0].zone_id : ""
}

output "lb_private_arn_suffix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn_suffix"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb.private[0].arn_suffix : ""
}

output "lb_public_arn_suffix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn_suffix"
  value       = var.enabled && !var.paused && var.enable_lb ? aws_lb.public[0].arn_suffix : ""
}

output "waf_web_acl_arn" {
  description = "ARN of the Web ACL, for attaching extra aws_wafv2_web_acl_rule resources from outside this module. The Web ACL carries ignore_changes on rule, so rules declared elsewhere are left alone. Use priorities 11-19 for rules that reject, so they run ahead of the allow rules, and 41-99 for rules that allow. https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#arn"
  value       = var.enabled && !var.paused && var.enable_waf ? try(aws_wafv2_web_acl.this[0].arn, "") : ""
}

output "waf_web_acl_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl#name"
  value       = var.enabled && !var.paused && var.enable_waf ? try(aws_wafv2_web_acl.this[0].name, "") : ""
}

output "waf_log_group_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group#name"
  value       = var.enabled && !var.paused && var.enable_waf ? try(aws_cloudwatch_log_group.waf[0].name, "") : ""
}

output "waf_ip_set_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set#arn"
  value       = var.enabled && !var.paused && var.enable_waf ? try(aws_wafv2_ip_set.allow_list[0].arn, "") : ""
}

output "waf_ip_set_addresses" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set#addresses"
  value       = var.enabled && !var.paused && var.enable_waf ? try(aws_wafv2_ip_set.allow_list[0].addresses, []) : []
}
