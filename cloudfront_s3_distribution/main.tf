## Dependencies

resource "aws_acm_certificate" "this" {
  domain_name               = var.alternate_domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

## CloudFront

resource "aws_wafv2_ip_set" "this" {
  name               = local.alternate_domain_name_sanitized
  description        = "Whitelisted IPs"
  scope              = "CLOUDFRONT"
  ip_address_version = "IPV4"
  addresses          = var.whitelisted_ip_addresses
}

resource "aws_cloudfront_distribution" "this" {
  aliases             = concat([var.alternate_domain_name], var.subject_alternative_names)
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_All"
  web_acl_id          = aws_wafv2_web_acl.this.arn

  default_cache_behavior {
    allowed_methods            = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods             = ["GET", "HEAD"]
    target_origin_id           = var.bucket_regional_domain_name
    cache_policy_id            = data.aws_cloudfront_cache_policy.managed_caching_optimized_policy.id
    origin_request_policy_id   = data.aws_cloudfront_origin_request_policy.managed_cors_s3_origin_policy.id
    compress                   = true
    response_headers_policy_id = data.aws_cloudfront_response_headers_policy.managed_cors_preflight_and_sec_policy.id
    viewer_protocol_policy     = "redirect-to-https"

    dynamic "function_association" {
      for_each = var.function_associations
      content {
        event_type   = function_association.value["event_type"]
        function_arn = function_association.value["function_arn"]
      }
    }
  }

  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = var.bucket_regional_domain_name
    origin_path = var.s3_folder_path

    s3_origin_config {
      origin_access_identity = var.cloudfront_access_identity_path
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.this.arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method       = "sni-only"
  }
}

## WAF

resource "aws_cloudwatch_log_group" "this" {
  name              = "aws-waf-logs-${local.alternate_domain_name_sanitized}"
  retention_in_days = 7
}

resource "aws_wafv2_web_acl" "this" {
  name        = local.alternate_domain_name_sanitized
  description = "WAF for CloudFront ${local.alternate_domain_name_sanitized}"
  scope       = "CLOUDFRONT"

  default_action {
    allow {}
  }

  rule {
    name     = "AWSManagedRulesAmazonIpReputationList"
    priority = 0

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAmazonIpReputationList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.alternate_domain_name_sanitized}-IpReputation"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesAnonymousIpList"
    priority = 1

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesAnonymousIpList"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.alternate_domain_name_sanitized}-AnonymousIp"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesCommonRuleSet"
    priority = 2

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.alternate_domain_name_sanitized}-CoreRules"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesKnownBadInputsRuleSet"
    priority = 3

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesKnownBadInputsRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.alternate_domain_name_sanitized}-BadInput"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedRulesSQLiRuleSet"
    priority = 4

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesSQLiRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.alternate_domain_name_sanitized}-SQL"
      sampled_requests_enabled   = true
    }
  }

  rule {
    name     = "AWSManagedulesLinuxRuleSet"
    priority = 5

    override_action {
      none {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesLinuxRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "${local.alternate_domain_name_sanitized}-Linux"
      sampled_requests_enabled   = true
    }
  }

  dynamic "rule" {
    for_each = local.create_waf_rule_to_whitelist_ips ? [1] : []
    content {
      name     = "WhitelistedIPs"
      priority = 6

      action {
        block {}
      }

      statement {
        not_statement {
          statement {
            ip_set_reference_statement {
              arn = aws_wafv2_ip_set.this.arn
            }
          }
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "${local.alternate_domain_name_sanitized}-WhitelistedIps"
        sampled_requests_enabled   = true
      }
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${local.alternate_domain_name_sanitized}-WAF"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_logging_configuration" "this" {
  log_destination_configs = [aws_cloudwatch_log_group.this.arn]
  resource_arn            = aws_wafv2_web_acl.this.arn

  logging_filter {
    default_behavior = "DROP"

    filter {
      behavior = "KEEP"
      condition {
        action_condition {
          action = "BLOCK"
        }
      }
      requirement = "MEETS_ALL"
    }
  }
}
