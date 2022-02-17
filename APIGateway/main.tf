provider "aws" {
    region = "ap-south-1"
}

#data for lambda
data "archive_file" "lambda-zip"{
    type = "zip"
    source_dir  = "LambdaFile"
    output_path = "lambda.zip"
}

#iam role for lambda
resource "aws_iam_role" "lambda_role" {
  name = "test_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    
    ]
  })

}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "dynamodb:*",
          "cloudwatch:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

#lambda function

resource "aws_lambda_function" "lambda"{
    filename  = "lambda.zip"
    function_name = "APIForDynamodb"
    role = aws_iam_role.lambda_role.arn 
    handler = "lambda.lambda_handler"
    source_code_hash = data.archive_file.lambda-zip.output_base64sha256
    runtime = "python3.8"

}

#api gateway

resource "aws_api_gateway_rest_api" "studentsAPI"{
    name = "StudentsInfo"
    description = "This api is for manupulating dynamodb"
}

resource "aws_api_gateway_resource" "studentAPIResource"{
    rest_api_id = aws_api_gateway_rest_api.studentsAPI.id
    parent_id  = aws_api_gateway_rest_api.studentsAPI.root_resource_id
    path_part  = "students"
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
  uri                     = aws_lambda_function.lambda.invoke_arn
  
}

resource "aws_api_gateway_integration" "lambdaIntegrationPOST"{
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  resource_id   = aws_api_gateway_resource.studentAPIResource.id
  http_method   = aws_api_gateway_method.studentPOST.http_method
  integration_http_method = "POST"  
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn

}

resource "aws_api_gateway_integration" "lambdaIntegrationDELETE"{
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  resource_id   = aws_api_gateway_resource.studentAPIResource.id
  http_method   = aws_api_gateway_method.studentDELETE.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
  
}

resource "aws_api_gateway_deployment" "gwDeployment" {
  rest_api_id = aws_api_gateway_rest_api.studentsAPI.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_rest_api.studentsAPI.body,
      aws_api_gateway_resource.studentAPIResource.id,
      aws_api_gateway_method.studentGET.id,
      aws_api_gateway_integration.lambdaIntegrationGET.id,
      aws_api_gateway_method.studentPOST.id,
      aws_api_gateway_integration.lambdaIntegrationPOST.id,
      aws_api_gateway_method.studentDELETE.id,
      aws_api_gateway_integration.lambdaIntegrationDELETE.id

    ]))
  }

}
resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.gwDeployment.id
  rest_api_id   = aws_api_gateway_rest_api.studentsAPI.id
  stage_name    = "version1"
}
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"


  source_arn = "arn:aws:execute-api:ap-south-1:439370943375:${aws_api_gateway_rest_api.studentsAPI.id}/*/${aws_api_gateway_method.studentGET.http_method}${aws_api_gateway_resource.studentAPIResource
  .path}"

}

#dynamodb

resource "aws_dynamodb_table" "StudentsInfo" {
  name           = "StudentsData"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "StudentId"

  attribute {
    name = "StudentId"
    type = "S"
  }
}

#API url
output "APIURL" {
  value       =  "${aws_api_gateway_stage.api_stage.invoke_url}/${aws_api_gateway_resource.studentAPIResource.path_part}"
}
