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

variable "default_action_redirect" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#default_action"
  type        = any
  default = {
    redirect = {
      port : 443,
      protocol : "HTTPS"
      status_code : "HTTP_301",
    }
  }
}

variable "default_action_fixed_response" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#default_action"
  type        = any
  default = {
    fixed_response = {
      content_type : "text/plain",
      message_body : "No valid routing rule"
      status_code : 400,
    }
  }
}