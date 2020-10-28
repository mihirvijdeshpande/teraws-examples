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
resource "aws_s3_bucket_object" "ll1dan_object" {
  key                    = "object1"
  bucket                 = aws_s3_bucket.s3.id
  source                 = "index.html"
  server_side_encryption = "AES256"
}

resource "aws_s3_bucket_object" "ll1dan_object2" {
  key                    = "object2"
  bucket                 = aws_s3_bucket.s3.id
  source                 = "home.html"
  server_side_encryption = "AES256"
}
resource "aws_s3_bucket_policy" "s3_policy" {
  bucket = aws_s3_bucket.s3.id
  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "PutObjPolicy",
  "Statement": [
    {
      "Sid": "DenyIncorrectEncryptionHeader",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::s3-bucket-name-1ll1dan/*",
      "Condition": {
        "StringNotEquals": {
          "s3:x-amz-server-side-encryption": "AES256"
        }
      }
    },
    {
      "Sid": "DenyUnEncryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "arn:aws:s3:::s3-bucket-name-1ll1dan/*",
      "Condition": {
        "Null": {
          "s3:x-amz-server-side-encryption": true
        }
      }
    }
  ]
}
  POLICY

}
