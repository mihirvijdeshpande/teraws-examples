resource "aws_s3_bucket" "website_bucket" {
  bucket = var.domain_name
  acl    = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = var.index_file
    error_document = var.home_file
  }
  logging {
    target_bucket = aws_s3_bucket.logs.bucket
    target_prefix = "www.${var.domain_name}/"
  }
}
resource "aws_s3_bucket" "logs" {
  bucket = "${var.domain_name}-site-logs"
  acl    = "log-delivery-write"
}
resource "aws_s3_bucket_object" "ll1dan_object1" {
  key          = var.index_file
  bucket       = aws_s3_bucket.website_bucket.id
  source       = var.index_file
  content_type = var.content_type
}

resource "aws_s3_bucket_object" "ll1dan_object2" {
  key          = var.home_file
  bucket       = aws_s3_bucket.website_bucket.id
  source       = var.home_file
  content_type = var.content_type
}
