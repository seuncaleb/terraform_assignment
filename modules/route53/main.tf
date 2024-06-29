resource "aws_route53_record" "route53_record" {
  for_each = {
    for dvo in var.more : dvo.domain_name => {
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
    name                   = var.alias_name
    zone_id                = var.alias_name
    evaluate_target_health = false
  }


}


 