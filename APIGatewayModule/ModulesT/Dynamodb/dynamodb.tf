resource "aws_dynamodb_table" "StudentsInfo" {
  name           = "${var.name}"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "StudentId"

  attribute {
    name = "StudentId"
    type = "S"
  }
}
