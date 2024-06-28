resource "aws_apigatewayv2_api" "example" {
  name          = var.domain_name
  protocol_type = "HTTP"
}