resource "aws_apigatewayv2_domain_name" "example" {
  domain_name = var.domain_name

  domain_name_configuration {
    certificate_arn = var.certificate_arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }
}

resource "aws_apigatewayv2_stage" "example" {
  api_id = aws_apigatewayv2_api.example.id
  name   = "example-stage"
}

resource "aws_apigatewayv2_api_mapping" "example" {
  api_id      = aws_apigatewayv2_api.example.id
  domain_name = aws_apigatewayv2_domain_name.example.id
  stage       = aws_apigatewayv2_stage.example.id
}