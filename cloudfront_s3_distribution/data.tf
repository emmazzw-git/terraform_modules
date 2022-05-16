data "aws_cloudfront_cache_policy" "managed_caching_optimized_policy" {
  name = "Managed-CachingOptimized"
}

data "aws_cloudfront_origin_request_policy" "managed_cors_s3_origin_policy" {
  name = "Managed-CORS-S3Origin"
}

data "aws_cloudfront_response_headers_policy" "managed_cors_preflight_and_sec_policy" {
  name = "Managed-CORS-with-preflight-and-SecurityHeadersPolicy"
}
