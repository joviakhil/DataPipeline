# Data Pipeline 

# S3 Bucket for input Data
resource "aws_s3_bucket" "my-demo-data-src-bucket" {
  bucket = var.source_bucket
}

# S3 Bucket for processed Data
resource "aws_s3_bucket" "my-demo-target-data-bucket" {
  bucket = var.target_bucket
}

# S3 Bucket for scripts 
resource "aws_s3_bucket" "my-demo-usr-scripts-bucket" {
  bucket = var.code_bucket
}

# S3 Bucket for athena results
resource "aws_s3_bucket" "my-demo-athena-results" {
  bucket = var.athena_results
}


# Create Glue Data Catalog Database
resource "aws_glue_catalog_database""demo_database" {
  name         = "demo_database"
  location_uri = "${aws_s3_bucket.my-demo-data-src-bucket.id}/"
}



resource "aws_glue_trigger""my_demo_glue_trigger" {
  name = "my_demo_glue_trigger"
  type = "ON_DEMAND"
  actions {
    crawler_name = aws_glue_crawler.my_demo_glue_crawler.name
  }
}

