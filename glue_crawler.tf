
resource "aws_lambda_permission" "allow_s3_lambda" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.glue_crawler_lambda_func.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.my-demo-data-src-bucket.arn
}

resource "aws_glue_classifier" "custom_json_classifier" {
  name = "custom_json_classifier"

  json_classifier {
    json_path = "$[*]"
  }
}
# Create Glue Crawler

resource "aws_glue_crawler" "my_demo_glue_crawler" {
  name          = "my_demo_glue_crawler"
  database_name = aws_glue_catalog_database.demo_database.name
  #classifiers=["aws_glue_classifier.custom_json_classifier.id"]
  #schedule      = "cron(0 1 * * ? *)"
  role          = aws_iam_role.glue_power_user_role.name
# dynamic "s3_target" {
#  for_each =var.glue_crawler_s3_target
#   content{
#       #path = "${aws_s3_bucket.my-demo-data-src-bucket.id}"
#       path= lookup(s3_target.value,"path",null)
#       connection_name     = lookup(s3_target.value, "connection_name", null)
#    }
#  }

 s3_target {
    path = "${aws_s3_bucket.my-demo-data-src-bucket.id}/"
  }
}

# Lambda function definition


resource "aws_lambda_function" "glue_crawler_lambda_func" {
filename                       = "${path.module}/python/lambda_python_scripts.zip"
function_name                  = "run_glue_crawler_with_lambda"
role                           = aws_iam_role.lambda_glue_role.arn
handler                        = "run_glue_crawler_job.lambda_handler"
runtime                        = "python3.8"
}



resource "aws_s3_bucket_notification" "bucket_notification_trigger" {
  bucket = aws_s3_bucket.my-demo-data-src-bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.glue_crawler_lambda_func.arn
    events              = ["s3:ObjectCreated:*"]

  }
}