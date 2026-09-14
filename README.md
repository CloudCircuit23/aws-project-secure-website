# The following Terraform configuration provisions an Amazon CloudFront distribution with Origin Access Control (OAC) and an Amazon S3 bucket to securely host a static website, with index.html serving as the default document.
# Security Objectives
- Deliver the private static website securely through Amazon CloudFront.
- Store website assets—including HTML, CSS, JavaScript, and images—in an Amazon S3 bucket.
- Enable S3 Block Public Access to prevent direct public access to bucket contents.
- Protect data with S3 versioning and server-side encryption.
- Enforce an S3 bucket policy that: Denies all non-HTTPS requests and permits object retrieval only from the authorized CloudFront distribution.
- Permits object retrieval only from the authorized CloudFront distribution.
- Configure CloudFront with Origin Access Control (OAC) to ensure the S3 origin is accessible only through CloudFront.
- Require HTTPS for all viewer requests to protect data in transit.
- Define a default root object, such as index.html, for website delivery.
