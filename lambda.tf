resource "aws_iam_role" "iam_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "access_buckets" {
  name = "lambda_buckets_policy"
  path        = "/"
  description = "lambda access to buckets"

   policy = jsonencode({
       Version = "2012-10-17",
       Statement = [
           {
                Effect = "Allow",
                Action = [
                    "s3:Get*",
                    "s3:List*"
                ],
                Resource = "arn:aws:s3:::${var.bucket_a}"
            },
            {
                Effect = "Allow",
                Action = [
                    "s3:List*",
                    "s3:Get*",
                    "s3:Put*"
                ],
                Resource = "arn:aws:s3:::${var.bucket_b}"
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = "${aws_iam_role.iam_lambda.name}"
  policy_arn = "${aws_iam_policy.access_buckets.arn}"
}

data "archive_file" "lambda_zip" {
    type        = "zip"
    source_dir  = "${path.module}/image_processor"
    output_path = "${path.module}/image_processor.zip"
}

resource "aws_lambda_function" "image_processor" {
  filename         = "${path.module}/image_processor.zip"
  function_name    = "image_processor"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"
  role             = "${aws_iam_role.iam_lambda.arn}"
  handler          = "image_processor.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
#  source_code_hash = filebase64sha256("image_processor.zip")

  runtime = "python3.9"

  environment {
    variables = {
      src_bucket = "${var.bucket_a}"
      dst_bucket = "${var.bucket_b}"
    }
  }

}

resource "aws_lambda_permission" "allow_bucket_notification" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_processor.arn
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.bucket_a}"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.bucket_a

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_processor.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.allow_bucket_notification]
}


#resource "aws_lambda_event_source_mapping" "event_source_mapping" {
#  event_source_arn = aws_sqs_queue.bucket_a_queue.arn
#  enabled          = true
#  function_name    = "${aws_lambda_function.image_processor.arn}"
#  batch_size       = 1
#}


