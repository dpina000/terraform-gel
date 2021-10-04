resource "aws_sqs_queue" "bucket_a_queue" {
  name = "bucket_a_event_queue"
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "arn:aws:sqs:*:*:s3-event-queue",
      "Condition": {
        "ArnEquals": { "aws:SourceArn": "arn:aws:s3:::${var.bucket_a}" }
      }
    }
  ]
}
POLICY
}


resource "aws_s3_bucket_notification" "bucket_a_notification" {
  bucket = var.bucket_a 

  queue {
    queue_arn     = aws_sqs_queue.bucket_a_queue.arn
    events        = ["s3:ObjectCreated:*"]
  }
}
