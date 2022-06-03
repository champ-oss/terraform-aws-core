output "ecs_cluster_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster#name"
  value       = aws_ecs_cluster.this.name
}

output "ecs_app_security_group" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#id"
  value       = aws_security_group.app.id
}

output "execution_ecs_role_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#arn"
  value       = aws_iam_role.this.arn
}

output "execution_ecs_role_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#name"
  value       = aws_iam_role.this.name
}

output "lb_private_listener_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn"
  value       = aws_lb_listener.private_https.arn
}

output "lb_public_listener_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn"
  value       = aws_lb_listener.public_https.arn
}

output "lb_public_dns_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name"
  value       = aws_lb.public.dns_name
}

output "lb_private_dns_name" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name"
  value       = aws_lb.private.dns_name
}

output "lb_public_zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id"
  value       = aws_lb.public.zone_id
}

output "lb_private_zone_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id"
  value       = aws_lb.private.zone_id
}
