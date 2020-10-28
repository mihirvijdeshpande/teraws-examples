resource "aws_s3_bucket" "website_bucket" {
  bucket = var.domain_name
  acl    = "public-read"
  policy = data.aws_iam_policy_document.website_policy.json
  website {
    index_document = "index.html"
    error_document = "home.html"
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
  key          = "index.html"
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "index.html"
  content_type = "text/html"
}

resource "aws_s3_bucket_object" "ll1dan_object2" {
  key          = "home.html"
  bucket       = aws_s3_bucket.website_bucket.id
  source       = "home.html"
  content_type = "text/html"
}
