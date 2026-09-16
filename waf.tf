# IP addresses which bypass the geo fencing rules below
resource "aws_wafv2_ip_set" "geo_fencing_bypass" {
  count              = var.enabled && !var.paused && var.enable_lb && var.enable_waf && local.waf_geo_fencing_bypass_enabled ? 1 : 0
  name               = "${var.git}-geo-fencing-bypass"
  description        = "IP addresses exempt from WAF geo fencing"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.waf_geo_fencing_allowed_cidrs
  tags               = merge(local.tags, var.tags)
}

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

# Geo fencing - block all traffic originating outside of the allowed countries
  dynamic "rule" {
    for_each = var.enable_waf_geo_fencing && length(var.waf_allowed_country_codes) > 0 ? [1] : []

    content {
      name     = "GeoFencingAllowedCountries"
      priority = 1

      action {
        block {}
      }

      statement {
        # With a bypass IP set: block only when the request is both out of country and off the list
        dynamic "and_statement" {
          for_each = local.waf_geo_fencing_bypass_enabled ? [1] : []

          content {
            statement {
              not_statement {
                statement {
                  geo_match_statement {
                    country_codes = var.waf_allowed_country_codes
                  }
                }
              }
            }

            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.geo_fencing_bypass[0].arn
                  }
                }
              }
            }
          }
        }

        dynamic "not_statement" {
          for_each = local.waf_geo_fencing_bypass_enabled ? [] : [1]

          content {
            statement {
              geo_match_statement {
                country_codes = var.waf_allowed_country_codes
              }
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.git}-GeoFencingAllowedCountries"
        sampled_requests_enabled   = true
      }
    }
  }

# Geo fencing - block all traffic originating from the blocked countries
  dynamic "rule" {
    for_each = var.enable_waf_geo_fencing && length(var.waf_blocked_country_codes) > 0 ? [1] : []

    content {
      name     = "GeoFencingBlockedCountries"
      priority = 2

      action {
        block {}
      }

      statement {
        dynamic "and_statement" {
          for_each = local.waf_geo_fencing_bypass_enabled ? [1] : []

          content {
            statement {
              geo_match_statement {
                country_codes = var.waf_blocked_country_codes
              }
            }

            statement {
              not_statement {
                statement {
                  ip_set_reference_statement {
                    arn = aws_wafv2_ip_set.geo_fencing_bypass[0].arn
                  }
                }
              }
            }
          }
        }

        dynamic "geo_match_statement" {
          for_each = local.waf_geo_fencing_bypass_enabled ? [] : [1]

          content {
            country_codes = var.waf_blocked_country_codes
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.git}-GeoFencingBlockedCountries"
        sampled_requests_enabled   = true
      }
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