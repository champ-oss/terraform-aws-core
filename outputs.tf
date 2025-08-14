output "ecs_cluster_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster#name"
  value       = var.enabled ? aws_ecs_cluster.this[0].name : ""
}

output "ecs_app_security_group" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#id"
  value       = var.enabled && !var.paused ? aws_security_group.app[0].id : ""
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
  value       = var.enabled && !var.paused ? aws_lb.private[0].arn : ""
}

output "lb_public_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn"
  value       = var.enabled && !var.paused ? aws_lb.public[0].arn : ""
}

output "lb_private_listener_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn"
  value       = var.enabled && !var.paused ? aws_lb_listener.private_https[0].arn : ""
}

output "lb_public_listener_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn"
  value       = var.enabled && !var.paused ? aws_lb_listener.public_https[0].arn : ""
}

output "lb_public_dns_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name"
  value       = var.enabled && !var.paused ? aws_lb.public[0].dns_name : ""
}

output "lb_private_dns_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name"
  value       = var.enabled && !var.paused  ? aws_lb.private[0].dns_name : ""
}

output "lb_public_zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id"
  value       = var.enabled && !var.paused  ? aws_lb.public[0].zone_id : ""
}

output "lb_private_zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id"
  value       = var.enabled && !var.paused  ? aws_lb.private[0].zone_id : ""
}

output "lb_private_arn_suffix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn_suffix"
  value       = var.enabled && !var.paused  ? aws_lb.private[0].arn_suffix : ""
}

output "lb_public_arn_suffix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#arn_suffix"
  value       = var.enabled && !var.paused  ? aws_lb.public[0].arn_suffix : ""
}
