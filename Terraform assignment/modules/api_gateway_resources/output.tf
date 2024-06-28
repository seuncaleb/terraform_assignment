output "certificate_arn" {
    value = aws_apigatewayv2_domain_name.example.domain_name_configuration.certificate_arn
}

output "domain_name" {
    value = aws_apigatewayv2_domain_name.example.domain_name_configuration[0].target_domain_name
}

output "zone_id" {
    value =  aws_apigatewayv2_domain_name.example.domain_name_configuration[0].hosted_zone_id
}

 
 