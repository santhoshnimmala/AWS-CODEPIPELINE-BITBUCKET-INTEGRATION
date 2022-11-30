resource "aws_api_gateway_rest_api" "restapi" {
  name        = "restapiforbitbucket"
  description = "This is bitbucket integration api"
}

resource "aws_api_gateway_resource" "bitbucket" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id
  parent_id   = aws_api_gateway_rest_api.restapi.root_resource_id
  path_part   = "bitbucket"
}
resource "aws_api_gateway_method" "trigger" {
  rest_api_id   = aws_api_gateway_rest_api.restapi.id
  resource_id   = aws_api_gateway_resource.bitbucket.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.restapi.id
  resource_id             = aws_api_gateway_resource.bitbucket.id
  http_method             = aws_api_gateway_method.trigger.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function_bit.invoke_arn
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function_bit.function_name
  principal     = "apigateway.amazonaws.com"

  # More: http://docs.aws.amazon.com/apigateway/latest/developerguide/api-gateway-control-access-using-iam-policies-to-invoke-api.html
  source_arn = "arn:aws:execute-api:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:${aws_api_gateway_rest_api.restapi.id}/*/${aws_api_gateway_method.trigger.http_method}${aws_api_gateway_resource.bitbucket.path}"
}

resource "aws_api_gateway_deployment" "bitbucket" {
  rest_api_id = aws_api_gateway_rest_api.restapi.id

  triggers = {
    # NOTE: The configuration below will satisfy ordering considerations,
    #       but not pick up all future REST API changes. More advanced patterns
    #       are possible, such as using the filesha1() function against the
    #       Terraform configuration file(s) or removing the .id references to
    #       calculate a hash against whole resources. Be aware that using whole
    #       resources will show a difference after the initial implementation.
    #       It will stabilize to only change when resources change afterwards.
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.bitbucket.id,
      aws_api_gateway_method.trigger.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.bitbucket.id
  rest_api_id   = aws_api_gateway_rest_api.restapi.id
  stage_name    = "prod"
}

