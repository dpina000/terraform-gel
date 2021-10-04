resource "aws_s3_bucket" "buckets_a" {
  count     = var.create_bucket ? 1 : 0
  bucket    = var.bucket_a
  acl       = "private"
  policy    = data.aws_iam_policy_document.bucket_a.json 
}

resource "aws_s3_bucket" "buckets_b" {
  count     = var.create_bucket ? 1 : 0
  bucket    = var.bucket_b
  acl       = "private"
  policy    = data.aws_iam_policy_document.bucket_b.json 
}

data "aws_iam_policy_document" "bucket_a" {
  statement {
    sid       = "UserAPermissions"
    actions   = [
      "s3:List*",
      "s3:Get*",
      "s3:Put*"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_a}",
      "arn:aws:s3:::${var.bucket_a}/*"
    ]
  }
}

data "aws_iam_policy_document" "bucket_b" {
  statement {
    sid       = "UserBPermissions"
    actions   = [
      "s3:List*",
      "s3:Get*"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_b}",
      "arn:aws:s3:::${var.bucket_b}/*"
    ]
  }
}
