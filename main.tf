terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# Generate random ID
resource "random_id" "rand_id" {
  byte_length = 8
}

# Create S3 bucket
resource "aws_s3_bucket" "website234_bucket" {
  bucket = "website234-bucket-${random_id.rand_id.hex}"
}

# Allow public access to the bucket
resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.website234_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 bucket policy
resource "aws_s3_bucket_policy" "website234" {
  bucket = aws_s3_bucket.website234_bucket.id

  policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Sid       = "PublicReadGetObject"
          Effect    = "Allow"
          Principal = "*"
          Action    = "s3:GetObject"
          Resource  = "arn:aws:s3:::${aws_s3_bucket.website234_bucket.id}/*"
        }
      ]
    }
  )
}

# Upload index.html
resource "aws_s3_object" "index_html" {
  bucket = aws_s3_bucket.website234_bucket.bucket
  source = "./index.html"
  key    = "index.html"
}

# Upload styles.css
resource "aws_s3_object" "styles_css" {
  bucket = aws_s3_bucket.website234_bucket.bucket
  source = "./styles.css"
  key    = "styles.css"
}

# Display random ID
output "name" {
  value = random_id.rand_id.hex
}