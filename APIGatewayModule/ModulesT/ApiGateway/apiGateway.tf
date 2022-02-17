resource "aws_api_gateway_rest_api" "studentsAPI"{
    name = "${var.apiName}"
    description = "This api is for manupulating dynamodb"
    endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "studentAPIResource"{
    rest_api_id = aws_api_gateway_rest_api.studentsAPI.id
    parent_id  = aws_api_gateway_rest_api.studentsAPI.root_resource_id
    path_part  = "${var.path_part}"
}

resource "aws_api_gateway_method" "studentGET" {
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  resource_id   = aws_api_gateway_resource.studentAPIResource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "studentPOST" {
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  resource_id   = aws_api_gateway_resource.studentAPIResource.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "studentDELETE" {
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  resource_id   = aws_api_gateway_resource.studentAPIResource.id
  http_method   = "DELETE"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambdaIntegrationGET"{
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  resource_id   = aws_api_gateway_resource.studentAPIResource.id
  http_method   = aws_api_gateway_method.studentGET.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
 # uri                     = aws_lambda_function.lambda.invoke_arn
  uri                     = "${var.invoke_arn}"
  
}

resource "aws_api_gateway_integration" "lambdaIntegrationPOST"{
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  resource_id   = aws_api_gateway_resource.studentAPIResource.id
  http_method   = aws_api_gateway_method.studentPOST.http_method
  integration_http_method = "POST"  
  type                    = "AWS_PROXY"
  #uri                     = aws_lambda_function.lambda.invoke_arn
  uri                     = "${var.invoke_arn}"
  
}

resource "aws_api_gateway_integration" "lambdaIntegrationDELETE"{
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  resource_id   = aws_api_gateway_resource.studentAPIResource.id
  http_method   = aws_api_gateway_method.studentDELETE.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  #uri                     = aws_lambda_function.lambda.invoke_arn
  uri                     = "${var.invoke_arn}"
  
}

resource "aws_api_gateway_deployment" "gwDeployment" {
  rest_api_id = aws_api_gateway_rest_api.studentsAPI.id

  triggers = {
    redeployment = sha1(jsonencode(
      aws_api_gateway_rest_api.studentsAPI.body
    ))
  }

}
resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.gwDeployment.id
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  stage_name    = "${var.stageName}"
}
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  #function_name = aws_lambda_function.lambda.function_name
  function_name = "${var.function_name}"
  principal     = "apigateway.amazonaws.com"


  source_arn = "arn:aws:execute-api:ap-south-1:439370943375:${aws_api_gateway_rest_api.studentsAPI.id}/*/${aws_api_gateway_method.studentGET.http_method}${aws_api_gateway_resource.studentAPIResource
  .path}"

}

output "APIURL" {
  value       =  "${aws_api_gateway_stage.api_stage.invoke_url}/${aws_api_gateway_resource.studentAPIResource.path_part}"
}
