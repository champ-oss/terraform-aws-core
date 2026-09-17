locals {
  # Accept either a bare IP ("1.2.3.4") or a CIDR ("1.2.3.0/24"); wafv2 ip_set requires CIDR notation
  waf_ip_allow_list = [for ip in var.waf_ip_allow_list : strcontains(ip, "/") ? ip : "${ip}/32"]

  # The allow list rule is only created once ranges have been added AND an action has been chosen.
  # Requiring both means an empty list can never block all traffic.
  enable_waf_ip_allow_list = length(var.waf_ip_allow_list) > 0 && var.waf_ip_allow_list_action != ""

  # Geo exempt list is deliberately separate from waf_ip_allow_list: it grants a WAF bypass
  # rather than restricting access, so the two lists rarely hold the same ranges.
  waf_geo_exempt_ip_list = [for ip in var.waf_geo_exempt_ip_list : strcontains(ip, "/") ? ip : "${ip}/32"]

  enable_waf_geo_exempt = length(var.waf_geo_exempt_ip_list) > 0 && var.waf_geo_exempt_action != ""
}

# Setup AWS WAF Web ACL
resource "aws_wafv2_web_acl" "this" {
  count = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
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
    metric_name              = "${var.git}-web-acl"
    sampled_requests_enabled = true
  }

  # Geo exempt - IPs in var.waf_geo_exempt_ip_list short-circuit the WAF (see var.waf_geo_exempt_action).
  # This runs at priority 0, and an "allow" action is terminating, so a match skips EVERY rule below:
  # the managed rule group, the geo block and the IP allow list. Run it in count mode first to see
  # which requests would be exempted without actually granting the bypass.
  dynamic "rule" {
    for_each = local.enable_waf_geo_exempt ? [1] : []
    content {
      name     = "IPGeoExempt"
      priority = 0

      statement {
        ip_set_reference_statement {
          arn = aws_wafv2_ip_set.geo_exempt[0].arn
        }
      }

      action {
        dynamic "count" {
          for_each = var.waf_geo_exempt_action == "count" ? [1] : []
          content {}
        }

        dynamic "allow" {
          for_each = var.waf_geo_exempt_action == "allow" ? [1] : []
          content {}
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.git}-IPGeoExempt"
        sampled_requests_enabled   = true
      }
    }
  }

  # Setup AWS Managed Rules - CommonRuleSet
  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 1

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

  # Geofencing - count or block all non-US traffic (see var.waf_geo_block_action)
  dynamic "rule" {
    for_each = length(var.waf_geo_block_action) > 0 ? [1] : []
    content {
      name     = "GeoBlockNonUS"
      priority = 2

      statement {
        not_statement {
          statement {
            geo_match_statement {
              country_codes = ["US"]
            }
          }
        }
      }

      action {
        dynamic "count" {
          for_each = var.waf_geo_block_action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = var.waf_geo_block_action == "block" ? [1] : []
          content {}
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.git}-GeoBlockNonUS"
        sampled_requests_enabled   = true
      }
    }
  }

  # IP allow list - count or block all traffic NOT originating from var.waf_ip_allow_list
  # (see var.waf_ip_allow_list_action). Run in count mode first and review the
  # ${var.git}-IPAllowList metric and sampled requests to find missing ranges before blocking.
  dynamic "rule" {
    for_each = local.enable_waf_ip_allow_list ? [1] : []
    content {
      name     = "IPAllowList"
      priority = 3

      statement {
        not_statement {
          statement {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.allow_list[0].arn
            }
          }
        }
      }

      action {
        dynamic "count" {
          for_each = var.waf_ip_allow_list_action == "count" ? [1] : []
          content {}
        }

        dynamic "block" {
          for_each = var.waf_ip_allow_list_action == "block" ? [1] : []
          content {}
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${var.git}-IPAllowList"
        sampled_requests_enabled   = true
      }
    }
  }
}

# IP ranges exempt from the WAF entirely, including the geo block. Kept separate from
# aws_wafv2_ip_set.allow_list because this grants a bypass rather than restricting access.
resource "aws_wafv2_ip_set" "geo_exempt" {
  count              = var.enabled && !var.paused && var.enable_lb && var.enable_waf && length(var.waf_geo_exempt_ip_list) > 0 ? 1 : 0
  name               = "${var.git}-waf-geo-exempt"
  description        = "IP ranges exempt from the WAF geo block for ${var.git}"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = local.waf_geo_exempt_ip_list
  tags               = merge(local.tags, var.tags)
}

# IP ranges allowed through the WAF. Created as soon as ranges are supplied so they can be
# staged and reviewed before var.waf_ip_allow_list_action turns the rule on.
resource "aws_wafv2_ip_set" "allow_list" {
  count              = var.enabled && !var.paused && var.enable_lb && var.enable_waf && length(var.waf_ip_allow_list) > 0 ? 1 : 0
  name               = "${var.git}-waf-ip-allow-list"
  description        = "IP ranges allowed through the WAF for ${var.git}"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = local.waf_ip_allow_list
  tags               = merge(local.tags, var.tags)
}

# Associate Web ACL with Public ALB
resource "aws_wafv2_web_acl_association" "this" {
  count        = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  resource_arn = aws_lb.public[0].arn
  web_acl_arn  = aws_wafv2_web_acl.this[count.index].arn
}

### Setup cloudwatch logs for WAF
resource "aws_cloudwatch_log_group" "waf" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  name_prefix = "aws-waf-logs-${var.git}-"
  tags        = merge(local.tags, var.tags)
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  count                   = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  log_destination_configs = [aws_cloudwatch_log_group.waf[count.index].arn]
  resource_arn            = aws_wafv2_web_acl.this[count.index].arn
  depends_on              = [aws_cloudwatch_log_resource_policy.this]
}

resource "aws_cloudwatch_log_resource_policy" "this" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  policy_name = "AWSLogs-${aws_cloudwatch_log_group.waf[count.index].name}-policy"

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
