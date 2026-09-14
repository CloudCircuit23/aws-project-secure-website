# This Terraform configuration sets up an S3 bucket for website hosting with security features such as public access blocking, versioning, server-side encryption, and ownership controls. It defines the necessary resources and configurations to ensure that the S3 bucket is secure and properly configured for hosting a website.
resource "aws_s3_bucket" "website_hosting" {
  bucket = var.website_bucket_name
  region = "us-east-2"

  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "website_security_group" {
  bucket = aws_s3_bucket.website_hosting.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "website_versioning" {
  bucket = aws_s3_bucket.website_hosting.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "website_encryption" {
  bucket = aws_s3_bucket.website_hosting.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_ownership_controls" "website_ownership" {
  bucket = aws_s3_bucket.website_hosting.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# This S3 bucket policy allows CloudFront to access the S3 bucket while denying any non-secure (HTTP) requests, ensuring that all access is done over HTTPS.
resource "aws_s3_bucket_policy" "cloudfront_access_bucket_policy" {
  bucket = aws_s3_bucket.website_hosting.id
  policy = data.aws_iam_policy_document.cloudfront_access.json
}


data "aws_iam_policy_document" "cloudfront_access" {
  statement {
    sid       = "AllowCloudFrontReadOnlyAccess"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_hosting.arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.website_distribution.arn]
    }
  }

  statement {
    sid       = "DenyNonSecureRequests"
    effect    = "Deny"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.website_hosting.arn}/*"]

        principals {
          type        = "AWS"
          identifiers = ["*"]
        }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }
}

# This Terraform configuration defines an AWS CloudFront distribution for a website hosted on S3. It specifies the origin, cache behavior, and viewer certificate settings.
resource "aws_cloudfront_distribution" "website_distribution" {
  origin {
    domain_name              = aws_s3_bucket.website_hosting.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_origin_access_control.id
    origin_id                = "S3-${aws_s3_bucket.website_hosting.arn}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "CloudFront distribution for website hosting"
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.website_hosting.arn}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
# This viewer policy setting ensures that all HTTP requests are redirected to HTTPS, enhancing security for users accessing the website.
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# This Terraform configuration sets up an AWS CloudFront Origin Access Control to allow CloudFront to securely access the S3 bucket. It specifies the origin type, signing behavior, and signing protocol to ensure that requests from CloudFront to the S3 bucket are properly authenticated and authorized.
resource "aws_cloudfront_origin_access_control" "cloudfront_origin_access_control" {
  name                              = "cloudfront-access-control"
  description                       = "Origin access control for CloudFront to access S3 bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}