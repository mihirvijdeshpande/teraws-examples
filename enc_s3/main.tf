provider "aws" {
  region     = "us-east-2"
  access_key = "somekey"
  secret_key = "somekey"
}
resource "aws_s3_bucket" "s3" {
  bucket        = "s3-bucket-name-1ll1dan"
  acl           = "private"
  force_destroy = true
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
