resource "aws_instance" "Ec2withAgent" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.Ec2withAgent.name
  user_data            = local.userdata
  tags                 = { Name = "EC2-with-cw-agent" }
}



resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to configure custom log"
  name        = "/cloudwatch-agent/config"
  type        = "String"
  value       = file("cw_agent_config.json")
}

# Create a VPC
resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_cloudwatch_log_group" "example_log_group" {
  name = "/example/logs"
  retention_in_days = 14 # Worth noting that you can change this to fit your compliance needs.
}