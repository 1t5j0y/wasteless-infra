output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.wasteless-api-gateway-deployment.invoke_url}"
}

output "add_point_api_invoke_arn" {
  value = "${aws_lambda_function.add-point.invoke_arn}"
}
