output "cloudfront_domain_name" {
  value       = "https://${module.secure-aws-website.domain_name}"
  description = "The domain name of the CloudFront distribution"
}

output "bucket_direct_s3_url" {
  value       = "https://${module.secure-aws-website.direct_s3_url}"
  description = "The direct URL to access the S3 bucket"
}
