
resource "aws_s3_bucket" "bucket_for_artifacts" {
  bucket = var.bucketname
  force_destroy = true
  acl    = "private"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "AWS_BITBUCKET_INETGRATION"
    Environment = "Dev"
  }
}
