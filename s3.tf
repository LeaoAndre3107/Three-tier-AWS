resource "aws_s3_bucket" "three_tier_bucket" {
  bucket = "three-tier-workshop-bucket-pratica"
}

resource "aws_s3_bucket_public_access_block" "this" {

  bucket                  = aws_s3_bucket.three_tier_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
