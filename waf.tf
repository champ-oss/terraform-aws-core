# Setup AWS WAF Web ACL. Rules live in aws_wafv2_web_acl_rule resources rather than inline rule
# blocks, so that deleting an IP set orders correctly against the rule referencing it and a
# change to one rule does not churn the others. That split requires ignore_changes on rule.
#
# Each dimension below is a terminating allow rule, so the dimensions OR together: a request
# matching any one of them is allowed immediately and the remaining rules never run. Populating
# waf_ip_allow_list alone therefore permits those addresses from anywhere, and adding
# waf_country_list widens what is permitted rather than narrowing it.
#
# The default action is block, so anything matching no allow rule is rejected. There is no
# permissive mode: the Web ACL enforces from the moment it is applied, and the precondition
# below is the only guard, refusing to plan a Web ACL with no allow rules at all.
resource "aws_wafv2_web_acl" "this" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  name        = "${var.git}-waf"
  description = "WAF for AWS Resources"
  scope       = "REGIONAL"
  tags        = merge(local.tags, var.tags)

  # Anything not allowed by a rule below is rejected here. Every rule below permits; this is the
  # only thing that turns traffic away, so with waf_country_list on its default the Web ACL
  # serves the US and rejects everywhere else.
  default_action {
    block {}
  }

  # Every rule below is named "${var.git}-<Rule>" and sets metric_name to the same string. Rule
  # names only have to be unique within a Web ACL, so the prefix is not required, but it means
  # several terraform-aws-core deployments in one account are told apart at a glance, and it
  # keeps one identifier for both worlds: the AWS/WAFV2 Rule dimension and terminatingRuleId in
  # the WAF logs are the same value, with no prefix to strip when moving between them.
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.git}-web-acl"
    sampled_requests_enabled   = true
  }

  lifecycle {
    ignore_changes = [rule]

    precondition {
      condition     = length(var.waf_ip_allow_list) + length(var.waf_country_list) > 0 || length(var.waf_state) > 0
      error_message = "enable_waf is true but no allow list is set. This Web ACL blocks by default, so with none of waf_ip_allow_list, waf_state or waf_country_list populated it would reject every request. Populate at least one, or set enable_waf to false."
    }
  }
}

# Priority 10 - AWS managed rules, created when var.waf_aws_managed_rules_action is set. This is
# the one rule that rejects rather than permits, and it runs ahead of the allow rules on purpose
# so that an allow listed address is still inspected for SQLi, XSS and the rest. On count the
# group runs in monitor mode, which also makes its per rule overrides inert; on block it
# enforces and those overrides start taking effect.
resource "aws_wafv2_web_acl_rule" "aws_managed" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf && length(var.waf_aws_managed_rules_action) > 0 ? 1 : 0
  name        = "${var.git}-AWSManagedCommonRuleSet"
  priority    = 10
  web_acl_arn = aws_wafv2_web_acl.this[0].arn

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
    dynamic "count" {
      for_each = var.waf_aws_managed_rules_action == "count" ? [1] : []
      content {}
    }

    dynamic "none" {
      for_each = var.waf_aws_managed_rules_action == "block" ? [1] : []
      content {}
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.git}-AWSManagedCommonRuleSet"
    sampled_requests_enabled   = true
  }
}

# Priority 20 - allow traffic from var.waf_ip_allow_list. Terminating, so a match here skips the
# state and country rules entirely.
resource "aws_wafv2_web_acl_rule" "ip_allow_list" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf && length(var.waf_ip_allow_list) > 0 ? 1 : 0
  name        = "${var.git}-IPAllowList"
  priority    = 20
  web_acl_arn = aws_wafv2_web_acl.this[0].arn

  statement {
    ip_set_reference_statement {
      arn = aws_wafv2_ip_set.allow_list[0].arn
    }
  }

  action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.git}-IPAllowList"
    sampled_requests_enabled   = true
  }
}

# Priority 29 - geo labels for the state rule at priority 30. AWS WAF has no state level match
# statement: geo_match_statement takes country codes only, and a state can be matched just one
# way, through the awswaf:clientip:geo:region label that AWS attaches to a request whenever a
# geo match statement inspects it. A label_match_statement only reads labels attached by a rule
# that already ran, so something has to run a geo match below priority 30 purely to produce
# them. That is all this rule is. It counts, so it tags traffic and passes it along rather than
# deciding anything, and it lives or dies with the state rule. The countries it inspects are
# derived from the state codes themselves, so the match always covers them.
resource "aws_wafv2_web_acl_rule" "geo_state_labels" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf && length(var.waf_state) > 0 ? 1 : 0
  name        = "${var.git}-GeoStateLabels"
  priority    = 29
  web_acl_arn = aws_wafv2_web_acl.this[0].arn

  statement {
    geo_match_statement {
      country_codes = [split("-", var.waf_state)[0]]
    }
  }

  action {
    count {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.git}-GeoStateLabels"
    sampled_requests_enabled   = true
  }
}

# Priority 30 - allow traffic from var.waf_state, matched on the label added at priority 29.
# Terminating, so a match here skips the country rule. One state only: label_match_statement
# takes a single key, unlike the country rule which hands a whole list to geo_match_statement.
# 31 to 39 are left free, so a second state can be attached from outside the module with the
# waf_web_acl_arn output.
resource "aws_wafv2_web_acl_rule" "state" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf && length(var.waf_state) > 0 ? 1 : 0
  name        = "${var.git}-StateList"
  priority    = 30
  web_acl_arn = aws_wafv2_web_acl.this[0].arn

  statement {
    label_match_statement {
      scope = "LABEL"
      key   = "awswaf:clientip:geo:region:${var.waf_state}"
    }
  }

  action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.git}-StateList"
    sampled_requests_enabled   = true
  }
}

# Priority 40 - allow traffic from a country in var.waf_country_list. Whole countries need no
# labels, so this reads geo_match_statement directly. Anything reaching the end of the rules
# unmatched is rejected by the block default.
resource "aws_wafv2_web_acl_rule" "country_list" {
  count       = var.enabled && !var.paused && var.enable_lb && var.enable_waf && length(var.waf_country_list) > 0 ? 1 : 0
  name        = "${var.git}-CountryList"
  priority    = 40
  web_acl_arn = aws_wafv2_web_acl.this[0].arn

  statement {
    geo_match_statement {
      country_codes = var.waf_country_list
    }
  }

  action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.git}-CountryList"
    sampled_requests_enabled   = true
  }
}

# IP ranges allowed through the WAF, referenced by the IPAllowList rule at priority 20. Created
# and destroyed on the same condition as that rule, and because the rule is its own resource the
# provider orders the two correctly rather than failing on WAFAssociatedItemException.
resource "aws_wafv2_ip_set" "allow_list" {
  count              = var.enabled && !var.paused && var.enable_lb && var.enable_waf && length(var.waf_ip_allow_list) > 0 ? 1 : 0
  name               = "${var.git}-waf-ip-allow-list"
  description        = "IP ranges allowed through the WAF for ${var.git}"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = var.waf_ip_allow_list
  tags               = merge(local.tags, var.tags)
}

# Associate Web ACL with Public ALB
resource "aws_wafv2_web_acl_association" "this" {
  count        = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  resource_arn = aws_lb.public[0].arn
  web_acl_arn  = aws_wafv2_web_acl.this[count.index].arn
}

# WAF logs. The group name MUST start with "aws-waf-logs-" - AWS rejects any other name as a
# logging destination, so this cannot be renamed to a /aws/waf/ style path. Named rather than
# name_prefix so the group is predictable: Logs Insights queries, saved queries and any external
# tooling can address it without a lookup, and the name survives a destroy and recreate.
resource "aws_cloudwatch_log_group" "waf" {
  count             = var.enabled && !var.paused && var.enable_lb && var.enable_waf ? 1 : 0
  name              = "aws-waf-logs-${var.git}"
  retention_in_days = var.waf_log_retention
  tags              = merge(local.tags, var.tags)
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
