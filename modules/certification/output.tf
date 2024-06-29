output "certification" {
    value = aws_acm_certificate_validation.example.certificate_arn
}

output "domain_validation" {
  value = aws_acm_certificate.acm_certificate
}
