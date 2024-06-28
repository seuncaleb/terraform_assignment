module "iam_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name        = "cloudfront-s3-access-policy"
  path        = "/"
  description = "Policy for CloudFront to access S3 bucket"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject"
      ],
      "Resource": "${module.s3_bucket.bucket_arn}/*"
    }
  ]
}
EOF
}

module "iam_assumable_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role"

  trusted_role_arns = [
    "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"
  ]

  create_role = true

  role_name         = "cloudfront-s3-access-role"
  role_requires_mfa = false

  custom_role_policy_arns = [
    module.iam_policy.arn
  ]
  number_of_custom_role_policy_arns = 1
}

