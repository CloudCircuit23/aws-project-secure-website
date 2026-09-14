output "domain_name" {
  value       = "https://${aws_cloudfront_distribution.website_distribution.domain_name}"
  description = "The domain name of the CloudFront distribution"
}

output "direct_s3_url" {
  value       = "https://${aws_s3_bucket.website_hosting.bucket_domain_name}"
  description = "The direct URL to access the S3 bucket"
}
