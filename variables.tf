variable "instance_name" {
  description = "Value of the Name tag for the EC2 instance"
  type        = string
  default     = "ec2FromVariableFile"
}

variable "aws_region" {
  description = "AWS region to deploy resources"
  default     = "us-east-1"
}

variable "source_bucket" {
  description = "S3 bucket for source data"
  default     = "my-demo-data-src-bucket"
}


variable "athena_results" {
  description = "S3 bucket for athena data"
  default     = "my-demo-athena-results"
}


variable "target_bucket" {
  description = "S3 bucket for target data"
  default     = "my-demo-target-data-bucket"
}

variable "code_bucket" {
  description = "S3 bucket for Glue job scripts"
  default     = "my-demo-usr-scripts-bucket"
}

variable "glue_crawler_s3_target" {
  description = "(Optional) List of nested S3 target arguments. "
  default     = []
}
