# S3 bucket for website.
resource "aws_s3_bucket" "www_bucket" {
  bucket = "www.${var.bucket_name}"
  acl    = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = "www.${var.bucket_name}" })


  #allowing these settings so the content length of our files is sent to Cloudfront - without this, not all files will have gzip compression resulting in reduced page performance
  cors_rule {
    allowed_headers = ["Authorization", "Content-Length"]
    allowed_methods = ["GET", "POST"]
    allowed_origins = ["https://www.${var.domain_name}"]
    max_age_seconds = 3000
  }

  website {
    index_document = "index.html"
    error_document = "error.html"
  }

  tags = var.tags
}

# S3 bucket for redirecting non-www to www.
resource "aws_s3_bucket" "root_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"
  policy = templatefile("templates/s3-policy.json", { bucket = var.bucket_name })

  website {
    redirect_all_requests_to = "https://www.${var.domain_name}"
  }

  tags = var.tags
}

#uploading the webpages to the buckets
resource "aws_s3_bucket_object" "www_bucket" {
  for_each = fileset("./dist/", "*")

  bucket       = "www.${var.bucket_name}"
  key          = each.value
  source       = "./dist/${each.value}"
  content_type = "text/html"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("./dist/${each.value}")
}

resource "aws_s3_bucket_object" "root_bucket" {
  for_each = fileset("./dist/", "*")

  bucket       = var.bucket_name
  key          = each.value
  source       = "./dist/${each.value}"
  content_type = "text/html"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  etag = filemd5("./dist/${each.value}")
}
