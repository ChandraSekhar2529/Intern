provider "aws"{
    region = "ap-south-1"
}

# data "archive_file" "lambda-zip"{
#     type = "zip"
#     source_dir  = "LambdaFile"
#     output_path = "lambda.zip"
# }


module "dynamodb_table"{
    source = "../ModulesT/Dynamodb"
    name = "StudentsData2"
}

module "lambdaFunction" {
    source = "../ModulesT/LambdaT"
    function_name  = "APIForDynamodb2"
    # filename = "${lambda.zip}"
}

module "apigateway"{
    source = "../ModulesT/ApiGateway"
    apiName = "StudentsInfo1"
    path_part = "students"
    stageName= "version1"
    invoke_arn = "${module.lambdaFunction.invoke_arn}"
    function_name = "${module.lambdaFunction.function_name}"
}

output url{
    value = "${module.apigateway.APIURL}"
}
