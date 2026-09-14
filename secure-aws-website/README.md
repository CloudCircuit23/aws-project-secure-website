# The following Terraform configuration provisions an Amazon S3 bucket with a secure bucket policy and an Amazon CloudFront distribution configured with Origin Access Control (OAC) to restrict direct access to the bucket’s content.
# Configurations
- Amazon S3 bucket configured with a secure bucket policy.
- S3 versioning to preserve and recover object versions.
- Server-side encryption to protect data at rest.
- S3 Object Ownership controls for consistent ownership and access management.
- Amazon CloudFront distribution with Origin Access Control (OAC) to securely serve content from the S3 origin.
