#creating an s3 bucket to store my statefile
resource "aws_s3_bucket" "bucketprofile2024" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "harriet" {
  bucket = aws_s3_bucket.bucketprofile2024.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "harriet" {
  bucket = aws_s3_bucket.bucketprofile2024.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "myacl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.harriet,
    aws_s3_bucket_public_access_block.harriet,

  ]
  bucket = aws_s3_bucket.bucketprofile2024.id
  acl    = "public-read"
}

resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.bucketprofile2024.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.bucketprofile2024.id
  key = "error.html"
  source = "error.html"
  acl = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "profile" {
  bucket = aws_s3_bucket.bucketprofile2024.id
  key = "profile.png"
  source = "profile.png"
  acl = "public-read"
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.bucketprofile2024.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.myacl ]
}

