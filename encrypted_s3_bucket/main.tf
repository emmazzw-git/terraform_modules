resource "aws_s3_bucket" "this" {
  bucket = var.name
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = var.number_of_days_objects_expire > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  rule {
    id = "ExpireAllObjects"

    expiration {
      days = var.number_of_days_objects_expire
    }

    filter {
      prefix = "*"
    }

    status = "Enabled"
  }
}
