provider "aws" {
  region = "${var.region}"
}

resource "aws_lambda_function" "add-point" {
  function_name = "add-point"
  handler = "app.lambdaHandler"
  description = ""
  runtime = "nodejs10.x"
  memory_size = 128
  role = "${aws_iam_role.lambda-iam-role.arn}"
  # s3_bucket = ""
  # s3_key = ""
  tags = {
    project = "${var.project}"
  }
}

resource "aws_lambda_permission" "api-gateway-invoke-lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.add-point.arn}"
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the specified API Gateway.
  source_arn = "${aws_api_gateway_deployment.wasteless-api-gateway-deployment.execution_arn}/*/*"
}

resource "aws_api_gateway_rest_api" "wasteless-api-gateway" {
  name = "WastelessAPI"
  description = "Wasteless Map APIs"
  body = "${data.template_file.wasteless-api-swagger.rendered}"
}

data "template_file" "wasteless-api-swagger" {
  template = "${file("wasteless-api.yaml")}"
  vars = {
    add_point_lambda_arn = "${aws_lambda_function.add-point.invoke_arn}"
  }
}

resource "aws_api_gateway_deployment" "wasteless-api-gateway-deployment" {
  rest_api_id = "${aws_api_gateway_rest_api.wasteless-api-gateway.id}"
  stage_name = "default"
}
