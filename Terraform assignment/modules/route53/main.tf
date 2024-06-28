
resource "aws_route53_record" "route53_record" {
  for_each = {
    for dvo in aws_acm_certificate.acm_certificate.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.example.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.example.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}


 