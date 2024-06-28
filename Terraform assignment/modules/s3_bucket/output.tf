output "bucket_domain" {
  value = aws_s3_bucket.s3_bucket.bucket_domain_name
}

output "bucket_arn" {
  value = aws_s3_bucket.s3_bucket.arn
}

