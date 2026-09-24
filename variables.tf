locals {
  tags = {
    git     = var.git
    cost    = "shared"
    creator = "terraform"
  }
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

variable "waf_log_retention" {
  description = "Retention period in days for WAF logs. Defaults to 365, a year, which is longer than var.log_retention holds ALB and container logs because WAF records are the evidence trail for who was allowed or rejected. Must be a value CloudWatch accepts; 0 keeps logs forever."
  type        = number
  default     = 365
}

variable "waf_aws_managed_rules_action" {
  description = "Sets the action for the AWS managed rule group at priority 10. Valid values are count (log only, the default) or block. Set to empty to leave the group out of the Web ACL entirely. This is the one rule that rejects rather than permits, and it runs ahead of the allow rules so that allow listed traffic is still inspected. On count the group runs in monitor mode, which also makes its per rule overrides inert, so promote it to block once the <git>-AWSManagedCommonRuleSet metric looks clean."
  type        = string
  default     = "count"
}

variable "waf_ip_allow_list" {
  description = "List of IPv4 CIDR ranges allowed through the WAF, for example [\"70.113.16.120/32\"]. Creates a terminating allow rule at priority 20; leave empty to omit it. The Web ACL blocks by default, so this widens what is permitted rather than narrowing it: an address listed here is allowed from anywhere, regardless of the state and country rules."
  type        = list(string)
  default     = []
}

variable "waf_state" {
  description = "A single ISO 3166-2 state code, for example \"US-TX\", allowed through the WAF. Creates a terminating allow rule at priority 30 plus the GeoStateLabels rule at priority 29 that supplies the label it matches on; leave empty to omit both. One state rather than a list because label_match_statement matches a single label key. Priorities 31 to 39 are left free, so further states can be attached with your own aws_wafv2_web_acl_rule resources using the waf_web_acl_arn output."
  type        = string
  default     = ""
}

variable "waf_country_list" {
  description = "ISO 3166-1 alpha-2 country codes allowed through the WAF, as a terminating allow rule at priority 40. Defaults to the US, so an otherwise unconfigured Web ACL allows US traffic and rejects everywhere else. Add countries to widen that, or set to [] to drop the rule, in which case one of the other lists has to permit your traffic instead."
  type        = list(string)
  default     = ["US"]
}

variable "idle_timeout" {
  description = "The idle timeout value for load balancers. The default is 60 seconds."
  type        = number
  default     = 60
}
