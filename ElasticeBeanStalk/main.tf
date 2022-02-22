resource "aws_elastic_beanstalk_application" "sample" {
  name        = "sample"
  description = "tf-test-desc"
}

resource "aws_elastic_beanstalk_environment" "sampleEnv" {
  name                = "sampleEnv"
  application         = aws_elastic_beanstalk_application.sample.name
  solution_stack_name = "64bit Amazon Linux 2015.03 v2.0.3 running Tomcat 8.5 "
}
