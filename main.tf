provider "aws"{
    profile= "default"
    region="us-east-1"
}



locals {
  userdata = templatefile("userdata.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name
  })
}





data "archive_file" "zip_the_python_code" {
type        = "zip"
source_dir  = "${path.module}/python/"
output_path = "${path.module}/python/lambda_python_scripts.zip"
}





