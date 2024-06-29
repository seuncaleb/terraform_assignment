# IAM Policy for CloudFront to access S3 bucket
data "aws_iam_policy_document" "s3_bucket_policy" {
  statement {
     sid    = "AllowPublicRead"
    effect = "Allow"
    actions = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.s3_bucket.arn}/*"]
  
  }
}
