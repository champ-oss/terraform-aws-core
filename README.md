# terraform-aws-core

A Terraform module for creating an AWS ECS Cluster and ALB

[![.github/workflows/module.yml](https://github.com/champ-oss/terraform-aws-core/actions/workflows/module.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-core/actions/workflows/module.yml)
[![.github/workflows/lint.yml](https://github.com/champ-oss/terraform-aws-core/actions/workflows/lint.yml/badge.svg?branch=main)](https://github.com/champ-oss/terraform-aws-core/actions/workflows/lint.yml)
[![.github/workflows/sonar.yml](https://github.com/champ-oss/terraform-aws-core/actions/workflows/sonar.yml/badge.svg)](https://github.com/champ-oss/terraform-aws-core/actions/workflows/sonar.yml)

[![SonarCloud](https://sonarcloud.io/images/project_badges/sonarcloud-black.svg)](https://sonarcloud.io/summary/new_code?id=terraform-aws-core_champ-oss)

[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-core_champ-oss&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=terraform-aws-core_champ-oss)
[![Vulnerabilities](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-core_champ-oss&metric=vulnerabilities)](https://sonarcloud.io/summary/new_code?id=terraform-aws-core_champ-oss)
[![Reliability Rating](https://sonarcloud.io/api/project_badges/measure?project=terraform-aws-core_champ-oss&metric=reliability_rating)](https://sonarcloud.io/summary/new_code?id=terraform-aws-core_champ-oss)

## Example Usage

See the `examples/` folder

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.38.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 6.38.0 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_athena_database.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_database) | resource |
| [aws_athena_named_query.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query) | resource |
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_iam_policy.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.lambda](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ses](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.textract](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_lb.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.private_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.private_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.public_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.public_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_certificate.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_lb_listener_certificate.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate) | resource |
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.app](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.alb_egress_ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_ingress_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.alb_ingress_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.app_egress_internet](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.app_ingress_alb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_wafv2_web_acl_rule.aws_managed](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_rule) | resource |
| [aws_wafv2_web_acl_rule.country_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_rule) | resource |
| [aws_wafv2_web_acl_rule.geo_state_labels](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_rule) | resource |
| [aws_wafv2_web_acl_rule.ip_allow_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_rule) | resource |
| [aws_wafv2_web_acl_rule.state_list](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_web_acl_rule) | resource |
| [time_sleep.wait_container_insight_logs](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [aws_caller_identity.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_elb_service_account.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/elb_service_account) | data source |
| [aws_iam_policy_document.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ssm_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_certificate_arns"></a> [additional\_certificate\_arns](#input\_additional\_certificate\_arns) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_certificate#certificate_arn | `list(string)` | `[]` | no |
| <a name="input_athena_workgroup"></a> [athena\_workgroup](#input\_athena\_workgroup) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/athena_named_query#workgroup | `string` | `"primary"` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#certificate_arn | `string` | n/a | yes |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule#cidr_blocks | `list(string)` | <pre>[<br>  "0.0.0.0/0"<br>]</pre> | no |
| <a name="input_enable_container_insights"></a> [enable\_container\_insights](#input\_enable\_container\_insights) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster#value | `bool` | `false` | no |
| <a name="input_git"></a> [git](#input\_git) | Identifier to be used on all resources | `string` | `"terraform-aws-core"` | no |
| <a name="input_log_retention"></a> [log\_retention](#input\_log\_retention) | Retention period in days for both ALB and container logs | `number` | `90` | no |
| <a name="input_name"></a> [name](#input\_name) | name to be used on all resources | `string` | `"terraform-aws-core"` | no |
| <a name="input_private_subnet_ids"></a> [private\_subnet\_ids](#input\_private\_subnet\_ids) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#subnet_ids | `list(string)` | n/a | yes |
| <a name="input_protect"></a> [protect](#input\_protect) | Enables deletion protection on eligible resources | `bool` | `true` | no |
| <a name="input_public_subnet_ids"></a> [public\_subnet\_ids](#input\_public\_subnet\_ids) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#subnets | `list(string)` | n/a | yes |
| <a name="input_ssl_policy"></a> [ssl\_policy](#input\_ssl\_policy) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#ssl_policy | `string` | `"ELBSecurityPolicy-TLS-1-2-2017-01"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | https://docs.aws.amazon.com/general/latest/gr/aws_tagging.html | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#vpc_id | `string` | n/a | yes |
| <a name="input_waf_aws_managed_rules_action"></a> [waf\_aws\_managed\_rules\_action](#input\_waf_aws_managed_rules_action) | Action for the AWS managed rule group at priority 10: count or block. Empty leaves the group out of the Web ACL. | `string` | `"count"` | no |
| <a name="input_waf_country_list"></a> [waf\_country\_list](#input\_waf_country_list) | ISO 3166-1 alpha-2 country codes allowed through the WAF; terminating allow rule at priority 40. Defaults to the US. | `list(string)` | <pre>[<br>  "US"<br>]</pre> | no |
| <a name="input_waf_ip_allow_list"></a> [waf\_ip\_allow\_list](#input\_waf_ip_allow_list) | IPv4 CIDR ranges allowed through the WAF; terminating allow rule at priority 20. | `list(string)` | `[]` | no |
| <a name="input_waf_log_retention"></a> [waf\_log\_retention](#input\_waf_log_retention) | Retention period in days for WAF logs. Defaults to 365; 0 keeps them forever. | `number` | `365` | no |
| <a name="input_waf_state"></a> [waf\_state](#input\_waf_state) | A single ISO 3166-2 state code allowed through the WAF; terminating allow rule at priority 30. | `string` | `"\"\""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_app_security_group"></a> [ecs\_app\_security\_group](#output\_ecs\_app\_security\_group) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group#id |
| <a name="output_ecs_cluster_name"></a> [ecs\_cluster\_name](#output\_ecs\_cluster\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster#name |
| <a name="output_execution_ecs_role_arn"></a> [execution\_ecs\_role\_arn](#output\_execution\_ecs\_role\_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#arn |
| <a name="output_execution_ecs_role_name"></a> [execution\_ecs\_role\_name](#output\_execution\_ecs\_role\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role#name |
| <a name="output_lb_private_dns_name"></a> [lb\_private\_dns\_name](#output\_lb\_private\_dns\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name |
| <a name="output_lb_private_listener_arn"></a> [lb\_private\_listener\_arn](#output\_lb\_private\_listener\_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn |
| <a name="output_lb_private_zone_id"></a> [lb\_private\_zone\_id](#output\_lb\_private\_zone\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id |
| <a name="output_lb_public_dns_name"></a> [lb\_public\_dns\_name](#output\_lb\_public\_dns\_name) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#dns_name |
| <a name="output_lb_public_listener_arn"></a> [lb\_public\_listener\_arn](#output\_lb\_public\_listener\_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener#arn |
| <a name="output_lb_public_zone_id"></a> [lb\_public\_zone\_id](#output\_lb\_public\_zone\_id) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb#zone_id |
| <a name="output_waf_ip_set_addresses"></a> [waf\_ip\_set\_addresses](#output\_waf_ip_set_addresses) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set#addresses |
| <a name="output_waf_ip_set_arn"></a> [waf\_ip\_set\_arn](#output\_waf_ip_set_arn) | https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/wafv2_ip_set#arn |
| <a name="output_waf_log_group_name"></a> [waf\_log\_group\_name](#output\_waf_log_group_name) | Name of the WAF CloudWatch log group, for Logs Insights queries |
| <a name="output_waf_web_acl_arn"></a> [waf\_web\_acl\_arn](#output\_waf_web_acl_arn) | ARN of the Web ACL, for attaching your own aws\_wafv2\_web\_acl\_rule resources |
| <a name="output_waf_web_acl_name"></a> [waf\_web\_acl\_name](#output\_waf_web_acl_name) | Name of the Web ACL |
<!-- END_TF_DOCS -->

## Features

### WAF

Setting `enable_waf = true` creates a Web ACL on the public ALB where each list below adds a
*terminating allow* rule. The dimensions **OR** together: a request matching any one of them is
allowed immediately and the remaining rules never run. Everything else is rejected by the default action.

The default action is always `block`, so with `waf_country_list` on its own default the Web ACL
serves US traffic and rejects everywhere else.

| Priority | Rule | Effect | Enabled by |
|----------|------|--------|------------|
| 10 | `<git>-AWSManagedCommonRuleSet` | counts or blocks matches in the AWS managed common group; counts by default | `waf_aws_managed_rules_action` |
| 20 | `<git>-IPAllowList` | allows `waf_ip_allow_list` | `waf_ip_allow_list` |
| 29 | `<git>-GeoStateLabels` | counts only, supplies the geo label | created with `waf_state` |
| 30 | `<git>-StateList` | allows `waf_state` | `waf_state` |
| 40 | `<git>-CountryList` | allows `waf_country_list`, the US by default | `waf_country_list` |
| – | default action | blocks everything unmatched | always |

`waf_country_list` defaults to `["US"]`, so an unconfigured Web ACL serves the US and rejects
everywhere else. That one rule is the line between allowed and rejected.

Each further list **widens** what is permitted rather than narrowing it. Adding
`waf_ip_allow_list` allows those addresses from anywhere in the world, *in addition to* all US
traffic.

`waf_state` takes a single state, not a list, because `label_match_statement` matches one label
key while `geo_match_statement` takes a whole list of countries. Priorities 31 to 39 are left
free, so a second state can be attached with your own rule using the `waf_web_acl_arn` output.

It is worth setting only for a subdivision of a country `waf_country_list` does not already
cover — `"CA-ON"` alongside `["US"]`, say. Setting `"US-TX"` alongside `["US"]` does change where
the request terminates, since priority 30 runs before 40, but it changes no access decision:
every Texas request the state rule allows would have been allowed by the country rule anyway.
All you get is that traffic counted under `<git>-StateList` instead of `<git>-CountryList`, plus
the label rule at priority 29.

The managed rule group at priority 10 is the one rule that rejects rather than permits, and it
runs ahead of the allow rules deliberately, so an allow listed address is still inspected for
SQLi, XSS and the rest before being let through. It defaults to `count`, which inspects and
records without rejecting anything; promote `waf_aws_managed_rules_action` to `block` once
`<git>-AWSManagedCommonRuleSet` shows no legitimate traffic being caught. Until then the geo and
IP rules are permitting traffic that has not actually been screened.

#### Before you enable it

There is no permissive mode. Allow rules have no count mode — a rule either passes traffic or it
does not exist — and the default action is always `block`, so the Web ACL enforces from the
moment it is applied. Get the lists right before turning it on, ideally against a sandbox stack.

Once it is live, everything it rejected is logged against `Default_Action`:

```
filter terminatingRuleId = "Default_Action"
| stats count(*) as blocked by httpRequest.country, httpRequest.clientIp
| sort blocked desc
```

Anything legitimate in that result means a list needs widening. The Web ACL carries a
`precondition` refusing to plan with none of the three lists populated, since that would reject
every request.

#### Upgrading from v1.0.139 or earlier

Rules moved from inline `rule` blocks on the Web ACL into separate `aws_wafv2_web_acl_rule`
resources, which means the Web ACL now carries `lifecycle { ignore_changes = [rule] }` and no
longer reconciles its inline rule set. A rule deployed by an older release would therefore
survive in AWS with nothing managing it.

**Disable the WAF, apply, then upgrade.**

1. On your current version, set `enable_waf = false` and apply. This destroys the Web ACL, and
   the inline rules go with it.
2. Bump the module version, set `enable_waf = true`, and apply again. Everything is recreated
   under the new structure.

Two things to know about the gap between those applies: the ALB has no Web ACL attached, so any
rule that was blocking stops blocking; and step 1 runs on your current version, where the WAF log
group is destroyed with everything else, taking its log events with it, so export anything you
need to keep first. Metrics restart under new names too, since every rule is renamed with a
`<git>` prefix in this release.

From this release the log group sets `skip_destroy`, so disabling the WAF or destroying the
module leaves the group and its log events in place, expiring after `waf_log_retention` days
(365 by default). It keeps the `aws-waf-logs-<git>-` name prefix so a later re-enable creates a
fresh group rather than colliding with the one left behind; `waf_log_group_name` outputs the
current one. The prefix is unchanged from earlier releases, so selecting log groups by the
`aws-waf-logs-<git>-` prefix in Logs Insights queries the old and new groups together. AWS requires the name to start with `aws-waf-logs-`, so it cannot be moved to a
`/aws/waf/` style path.

| Change | Effect |
|--------|--------|
| Provider floor `>= 4.0.0` → `>= 6.38.0` | `terraform init` fails on 5.x, even with `enable_waf = false`. Upgrade the provider first. |
| `waf_geo_block_action` removed | Plan fails with `Unsupported argument`. Use `waf_country_list`, which allows the countries you serve instead of rejecting everything outside the US. |
| `waf_ip_allow_list_action` removed | Plan fails with `Unsupported argument`. The IP list no longer has a count mode; rehearse at the default action instead. |
| Default action is now `block` | **Traffic from outside `waf_country_list` is rejected as soon as this is applied.** There is no permissive mode; verify your lists in a sandbox first. |
| `IPAllowList` inverted | Was "block what is not listed", now "allow what is listed". A list previously kept on `count` for observation becomes load bearing. |
| Rules renamed and renumbered | `IPAllowList` at priority 2 becomes `<git>-IPAllowList` at priority 20. |

#### Adding your own rules

Because rules are separate resources and the Web ACL carries `ignore_changes = [rule]`, rules
declared outside this module are left alone. Attach them with the `waf_web_acl_arn` output:

```hcl
resource "aws_wafv2_web_acl_rule" "rate_limit" {
  name        = "${local.git}-RateLimit"
  priority    = 15
  web_acl_arn = module.core.waf_web_acl_arn

  statement {
    rate_based_statement {
      limit              = 2000
      aggregate_key_type = "IP"
    }
  }

  action {
    block {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.git}-RateLimit"
    sampled_requests_enabled   = true
  }
}
```

**Priority matters more than usual here, because allow rules terminate.** A rule that rejects
has to run *before* the allow rules or it will never be reached by traffic those rules already
passed. Use:

| Range | For | Why |
|-------|-----|-----|
| 11–19 | rules that reject or count | ahead of every allow rule, so they inspect all traffic |
| 41–99 | rules that allow | after `<git>-CountryList`, widening what gets through |

Avoid 10, 20, 29, 30 and 40, which this module owns; 31 to 39 are free. Give rules a `<git>` prefix so they
stay unique and legible alongside the module's own.

#### Querying

Because allow rules are what pass traffic, each rule's CloudWatch metric counts what it
**permitted**, and a terminating match means a request is counted by exactly one rule. Summing
`<git>-IPAllowList`, `<git>-StateList` and `<git>-CountryList` gives you allowed traffic broken
down by the reason it was allowed, with no double counting.

Every rule is named `<git>-<Rule>` and uses that same string as its CloudWatch `metric_name`, so
one identifier works in both worlds: the `Rule` dimension under `AWS/WAFV2` and
`terminatingRuleId` in a Logs Insights query. Rule names only have to be unique within a Web
ACL, so the prefix is not required, but it tells several terraform-aws-core deployments in one
account apart at a glance.

Rejected requests match no rule at all, so they appear only in the Web ACL's `BlockedRequests`
metric, not under any rule name. To find out why something was rejected, query the WAF logs for
`terminatingRuleId = "Default_Action"` and read the request's own fields; when `waf_state`
is in use, the labels added at priority 29 are on the log record too.

Rules are managed as separate `aws_wafv2_web_acl_rule` resources rather than inline `rule`
blocks, which is why the module requires AWS provider `>= 6.38.0`. That ordering lets an IP set
be deleted safely while a rule references it, and keeps a change to one rule from churning the
others. The Web ACL therefore carries `lifecycle { ignore_changes = [rule] }`, as the provider
requires.

## Contributing


