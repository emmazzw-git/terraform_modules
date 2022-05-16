data "aws_iam_policy_document" "prevent_s3_uploads_of_unencrypted_S3_objects" {
  statement {
    sid = "DenyIncorrectEncryptionHeader"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    effect    = "Deny"
    condition {
      test     = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values   = ["AES256"]
    }
  }

  statement {
    sid = "DenyUnEncryptedObjectUploads"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    effect    = "Deny"
    condition {
      test     = "Null"
      variable = "s3:x-amz-server-side-encryption"
      values   = [true]
    }
  }
}

data "aws_iam_policy_document" "this" {
  source_policy_documents = [
    data.aws_iam_policy_document.prevent_s3_uploads_of_unencrypted_S3_objects.json,
    jsondecode(var.bucket_policy)
  ]
}
