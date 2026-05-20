# Setup AWS WAF Web ACL
resource "aws_wafv2_web_acl" "this" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  #name       = "${aws_lb.public[0].name}-waf"
  name        = "${var.git}-waf"
  description = "WAF for AWS Resources"
  scope       = "REGIONAL"
  tags        = merge(local.tags, var.tags)

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    #metric_name                 = "${aws_lb.public[0].name}-web-acl"
    metric_name = "${var.git}-web-acl"
    sampled_requests_enabled     = true
  }

# Setup AWS Managed Rules - CommonRuleSet
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 0
    
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
        # Override specific rules to Count
        

        rule_action_override {
          name = "NoUserAgent_HEADER"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "UserAgent_BadBots_HEADER"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "SizeRestrictions_QUERYSTRING"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "SizeRestrictions_Cookie_HEADER"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "SizeRestrictions_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "SizeRestrictions_URIPATH"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "EC2MetaDataSSRF_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "EC2MetaDataSSRF_COOKIE"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "EC2MetaDataSSRF_URIPATH"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "EC2MetaDataSSRF_QUERYARGUMENTS"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "GenericLFI_QUERYARGUMENTS"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "GenericLFI_URIPATH"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "GenericLFI_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "RestrictedExtensions_URIPATH"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "RestrictedExtensions_QUERYARGUMENTS"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "GenericRFI_QUERYARGUMENTS"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "GenericRFI_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "GenericRFI_URIPATH"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "CrossSiteScripting_COOKIE"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "CrossSiteScripting_QUERYARGUMENTS"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "CrossSiteScripting_BODY"
          action_to_use {
            count {}
          }
        }
        rule_action_override {
          name = "CrossSiteScripting_URIPATH"
          action_to_use {
            count {}
          }
        }
      }
    }
    
    override_action {
      count {}
    }
    
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${var.git}-AWSManagedCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }
}

# Associate Web ACL with Public ALB
resource "aws_wafv2_web_acl_association" "this" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  resource_arn = aws_lb.public[0].arn
  web_acl_arn  = aws_wafv2_web_acl.this[count.index].arn
}

### Setup cloudwatch logs for WAF
resource "aws_cloudwatch_log_group" "waf" {
  count             = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  name_prefix       = "aws-waf-logs-${var.git}-"
  tags              = merge(local.tags, var.tags)
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  count                   = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  log_destination_configs = [aws_cloudwatch_log_group.waf[count.index].arn]
  resource_arn            = aws_wafv2_web_acl.this[count.index].arn
  depends_on              = [aws_cloudwatch_log_resource_policy.this]
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  count           = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  policy_name     = "AWSLogs-${aws_cloudwatch_log_group.waf[count.index].name}-policy"

  policy_document = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid    = "AWSWAFLoggingPermissions",
        Effect = "Allow",
        
        Principal = {
          Service = "delivery.logs.amazonaws.com"
        },
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"          
        ],
        Resource = "${aws_cloudwatch_log_group.waf[count.index].arn}:*"
      }
    ]
  })
}