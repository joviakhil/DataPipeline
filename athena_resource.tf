

resource "aws_athena_database" "s3_using_athena" {
  name   = "s3_using_athena"
  bucket = aws_s3_bucket.my-demo-athena-results.id
}
