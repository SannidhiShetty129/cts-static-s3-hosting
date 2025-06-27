provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "s3_hosting_bucket" {
  bucket = "s3-hosting-2397710"

  website {
    index_document = "index.html"
  }

  tags = {
    Project = "S3HostingStaticSite"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_public_access_block" "s3_hosting_public_access_block" {
  bucket = aws_s3_bucket.s3_hosting_bucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "s3_hosting_bucket_policy" {
  bucket = aws_s3_bucket.s3_hosting_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "PublicReadGetObject",
        Effect = "Allow",
        Principal = "*",
        Action = "s3:GetObject",
        Resource = [
          "${aws_s3_bucket.s3_hosting_bucket.arn}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.s3_hosting_public_access_block]
}

output "website_endpoint" {
  value = aws_s3_bucket.s3_hosting_bucket.website_endpoint
}