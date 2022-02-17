resource "aws_lambda_function" "lambda"{
    filename  = "lambda.zip"
    function_name = "${var.function_name}"
    role = aws_iam_role.lambda_role.arn 
    handler = "lambda.lambda_handler"
    source_code_hash = data.archive_file.lambda-zip.output_base64sha256
    runtime = "python3.8"
}

data "archive_file" "lambda-zip"{
    type = "zip"
    source_dir  = "lambdaFile"
    output_path = "lambda.zip"
}

resource "aws_iam_role" "lambda_role" {
  name = "test_role1"

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

output "invoke_arn" {
  value       = "${aws_lambda_function.lambda.invoke_arn}"
}

output "function_name"{
    value = "${aws_lambda_function.lambda.function_name}"
}

