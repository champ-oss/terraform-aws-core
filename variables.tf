locals {
  tags = {
    git     = var.git
    cost    = "shared"
    creator = "terraform"
  }

  # Geo fencing bypass is only wired up when an explicit list of CIDRs is supplied
  waf_geo_fencing_bypass_enabled = var.enable_waf_geo_fencing && var.waf_geo_fencing_allowed_cidrs != null && length(coalesce(var.waf_geo_fencing_allowed_cidrs, [])) > 0
}

variable "git" {
  description = "Identifier to be used on all resources"
  default     = "terraform-aws-core"
  type        = string
}

variable "name" {
  type        = string
  description = "name to be used on all resources"
  default     = "terraform-aws-core"
}

variable "tags" {
  description = "https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html"
  type        = map(string)
  default     = {}
}

variable "certificate_arn" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#certificate_arn"
  type        = string
}

variable "additional_certificate_arns" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate#certificate_arn"
  type        = list(string)
  default     = []
}

variable "public_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#subnets"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#subnet_ids"
  type        = list(string)
}

variable "vpc_id" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#vpc_id"
  type        = string
}

variable "ssl_policy" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#ssl_policy"
  type        = string
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "log_retention" {
  description = "Retention period in days for both ALB and container logs"
  type        = number
  default     = 90
}

variable "cidr_blocks" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#cidr_blocks"
  default     = ["0.0.0.0/0"]
  type        = list(string)
}

variable "enable_container_insights" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster#value"
  type        = bool
  default     = false
}

variable "connection_logs_prefix" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#connection_logs"
  type        = string
  default     = null
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
}

variable "paused" {
  description = "Set to true to pause the resource"
  type        = bool
  default     = false
}

variable "central_audit_bucket" {
  description = "S3 bucket for centralizing ALB access logs and connection logs."
  type        = string
  default     = null
}

variable "enable_deletion_protection" {
  description = "Enables deletion protection on eligible resources"
  type        = bool
  default     = true
}

variable "enable_extra_alb_public_sg" {
  description = "Enables creation of a security group for the public alb"
  type        = bool
  default     = false
}

variable "enable_lb" {
  description = "Enables creation of load balancers and related resources"
  type        = bool
  default     = true
}

variable "enable_waf" {
  description = "Enables creation of WAF for load balancers and related resources"
  type        = bool
  default     = false
}

variable "idle_timeout" {
  description = "The idle timeout value for load balancers. The default is 60 seconds."
  type        = number
  default     = 60
}

variable "enable_waf_geo_fencing" {
  description = "Enables geo fencing rules on the WAF Web ACL (requires enable_waf)"
  type        = bool
  default     = false
}

variable "waf_allowed_country_codes" {
  description = "Two letter ISO 3166-1 alpha-2 country codes allowed to reach the load balancer. When geo fencing is enabled and this list is set, requests originating from any other country are blocked."
  type        = list(string)
  default     = ["US"]
}

variable "waf_blocked_country_codes" {
  description = "Two letter ISO 3166-1 alpha-2 country codes blocked from reaching the load balancer. Only used when geo fencing is enabled."
  type        = list(string)
  default     = []
}

variable "waf_geo_fencing_allowed_cidrs" {
  description = "IPv4 CIDRs that are exempt from the WAF geo fencing rules, for example offshore contractors or VPN egress addresses. Leave null to skip creating the IP set entirely."
  type        = list(string)
  default     = null
}
