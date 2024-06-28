terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.50.0"
    }
  }
}

module "s3_bucket" {
  source = "./modules/s3_bucket"
}

module "certification" {
  source = "./modules/certification"
  domain_name = var.domain_name
}

module "api_gateway_config" {
  source = "./modules/api_gateway_config"
  domain_name = var.domain_name
}

module "route53" {
  source = "./modules/route53"
  domain_name = var.domain_name
  
}

module "api_gateway_resources" {
  source = "./modules/api_gateway_resources"
  domain_name = var.domain_name
  certificate_arn = module.certification.certification
}


module "cdn" {
  source = "terraform-aws-modules/cloudfront/aws"

  aliases = ["seuncaleb.co.uk"]

  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_All"
  retain_on_delete    = false
  wait_for_deployment = false

  create_origin_access_identity = true
  origin_access_identities = {
    s3_bucket_one = "My awesome CloudFront can access"
  }

  logging_config = {
    bucket = "${module.s3_bucket.bucket_domain}"
  }

  origin = {
    something = {
      domain_name = module.s3_bucket.bucket_domain
      custom_origin_config = {
        http_port              = 80
        https_port             = 443
        origin_protocol_policy = "match-viewer"
        origin_ssl_protocols   = ["TLSv1", "TLSv1.1", "TLSv1.2"]
      }
    }

    s3_one = {
      domain_name = "${module.s3_bucket.bucket_domain}" 
      s3_origin_config = {
        origin_access_identity = "s3_bucket_one"
      }
    }
  }

  default_cache_behavior = {
    target_origin_id       = "something"
    viewer_protocol_policy = "allow-all"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true
  }

  ordered_cache_behavior = [
    {
      path_pattern           = "/static/*"
      target_origin_id       = "s3_one"
      viewer_protocol_policy = "redirect-to-https"

      allowed_methods = ["GET", "HEAD", "OPTIONS"]
      cached_methods  = ["GET", "HEAD"]
      compress        = true
      query_string    = true
    }
  ]

  viewer_certificate = {
    acm_certificate_arn = module.api_gateway_resources.certificate_arn
    ssl_support_method  = "sni-only"
  }

  default_root_object = "index.html"

  tags = {
    Environment = "production"
  }


}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "Access identity for S3 bucket"
}


