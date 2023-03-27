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

variable "protect" {
  description = "Enables deletion protection on eligible resources"
  type        = bool
  default     = true
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

variable "athena_workgroup" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query#workgroup"
  type        = string
  default     = "primary"
}

variable "load_balancer_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#load_balancer_type"
  type        = string
  default     = "application"
}

variable "default_action_fixed_response" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#default_action"
  type        = string
  default     = "fixed-response"
}

variable "default_action_http" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#default_action"
  type        = string
  default     = "redirect"
}


variable "fixed_response_content_type" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#status_code"
  type        = string
  default     = "text/plain"
}

variable "fixed_response_message_body" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#status_code"
  type        = string
  default     = "No valid routing rule"
}

variable "fixed_response_status_code" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#status_code"
  type        = string
  default     = "400"
}

variable "redirect_port" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#status_code"
  type        = string
  default     = "443"
}

variable "redirect_protocol" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#status_code"
  type        = string
  default     = "HTTPS"
}

variable "redirect_status_code" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#status_code"
  type        = string
  default     = "HTTP_301"
}

variable "aws_lb_target_group" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#status_code"
  type        = string
  default     = ""
}

variable "default_action_redirect" {
  type        = any
  description = "(Required) Configuration block for default actions."
  default = {
    redirect_response = {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

variable "default_action_forward" {
  type        = any
  description = "(Required) Configuration block for default actions."
  default     = null
}
