resource "aws_iam_user" "user_a" {
  name = "${var.user_a}"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_group" "user_a_group" {
  name = "user_a_group"
}

resource "aws_iam_user" "user_b" {
  name = "${var.user_b}"
  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_iam_group" "user_b_group" {
  name = "user_b_group"
}

resource "aws_iam_group_policy" "user_a_policy" {
  name  = "user_a_policy"
  group = aws_iam_group.user_a_group.name
  policy = data.aws_iam_policy_document.user_a_policy.json
}

resource "aws_iam_group_membership" "user_a_group_membership" {
  name  = "user_a_group_membership"
  users = [ aws_iam_user.user_a.name ]
  group = aws_iam_group.user_a_group.name
}

resource "aws_iam_group_policy" "user_b_policy" {
  name  = "user_b_policy"
  group = aws_iam_group.user_b_group.name
  policy = data.aws_iam_policy_document.user_b_policy.json
}

resource "aws_iam_group_membership" "user_b_group_membership" {
  name  = "user_a_group_membership"
  users = [ aws_iam_user.user_b.name ]
  group = aws_iam_group.user_b_group.name
}

data "aws_iam_policy_document" "user_a_policy" {
  statement {
    sid       = "AllowAccessToBucketA"
    actions   = [
      "s3:Put*",
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
        "arn:aws:s3:::${var.bucket_a}",
        "arn:aws:s3:::${var.bucket_a}/*"
      ]
  }
}

data "aws_iam_policy_document" "user_b_policy" {
  statement {
    sid       = "AllowAccessToBucketB"
    actions   = [
      "s3:Get*",
      "s3:List*"
    ]
    resources = [
        "arn:aws:s3:::${var.bucket_b}",
        "arn:aws:s3:::${var.bucket_b}/*"
      ]
  }
}

