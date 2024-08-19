#Creating an S3 Bucket
resource "aws_s3_bucket" "s3" {
  bucket = "git-hubbucketsumanth.com"
}

#Defining Owner of the bucket
resource "aws_s3_bucket_ownership_controls" "owner" {
  bucket = aws_s3_bucket.s3.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Allowing Public Access
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.s3.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#Defining Acl Rules
resource "aws_s3_bucket_acl" "acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.owner,
    aws_s3_bucket_public_access_block.block,
  ]

  bucket = aws_s3_bucket.s3.id
  acl    = "public-read"
}

#Copying idex.html to s3
resource "aws_s3_object" "index" {
  bucket = aws_s3_bucket.s3.id
  key = "index.html"
  source = "index.html"
  acl = "public-read"
}

#Copying error.html to s3
resource "aws_s3_object" "error" {
  bucket = aws_s3_bucket.s3.id
  key = "./error.html"
  source = "./error.html"
  acl = "public-read"
}

#Static website configuration
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.s3.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
  depends_on = [ aws_s3_bucket_acl.acl ]
}