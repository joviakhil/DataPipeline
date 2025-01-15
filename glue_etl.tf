
resource "aws_lambda_function" "terraform_lambda_func" {
filename                       = "${path.module}/python/lambda_python_scripts.zip"
function_name                  = "run_glue_with_lambda"
role                           = aws_iam_role.lambda_glue_role.arn
handler                        = "run_glue_job.lambda_handler"
runtime                        = "python3.8"
#depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}



resource "aws_cloudwatch_event_rule" "glue_crawl_end" {
  name        = "glue_crawl_end"
  description = "end of glue crawl"

  event_pattern = <<PATTERN
{
    "detail-type": [
        "Glue Crawler State Change"
    ],
    "source": [
        "aws.glue"
    ],
    "detail": {
        "crawlerName": [
            "my_demo_glue_crawler"
        ],
        "state": [
            "Succeeded"
        ]
    }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "trigger_lambda_post_crawl" {
  rule      = aws_cloudwatch_event_rule.glue_crawl_end.name
  target_id = "terraform_lambda_func"
  arn       =  aws_lambda_function.terraform_lambda_func.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_lambda" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.terraform_lambda_func.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.glue_crawl_end.arn
}

resource "aws_glue_job""my_demo_glue_job" {
  name              = "my_demo_glue_job"
  role_arn          = aws_iam_role.glue_power_user_role.arn
  description       = "Transfer Json from source to bucket"
  glue_version      = "4.0"
  worker_type       = "G.1X"
  timeout           = 2880
  max_retries       = 1
  number_of_workers = 2
  command {
    name            = "glueetl"
    python_version  = 3
    script_location = "s3://${aws_s3_bucket.my-demo-usr-scripts-bucket.id}/GlueETLJob.py"
  }
    default_arguments = {
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-continuous-log-filter"     = "true"
    "--enable-metrics"                   = ""
    "--source-path"                     = "s3://${aws_s3_bucket.my-demo-data-src-bucket.id}/" # Specify the source S3 path
    "--destination-path"                = "s3://${aws_s3_bucket.my-demo-target-data-bucket.id}/" # Specify the destination S3 path
  }

}
