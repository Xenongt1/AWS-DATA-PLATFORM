# ============================================
# LAB 1.3: S3 DATA LAKE FOUNDATION
# ============================================

# Main Data Lake Bucket
resource "aws_s3_bucket" "data_lake" {
  bucket        = "data-lake-prod-tf-899957567386"
  force_destroy = true

  tags = {
    Environment = "Production"
    Owner       = "DataEngineering"
    Purpose     = "DataLake"
    CostCenter  = "Analytics"
  }
}

# Logging Bucket
resource "aws_s3_bucket" "data_lake_logs" {
  bucket        = "data-lake-prod-logs-tf-899957567386"
  force_destroy = true

  tags = {
    Environment = "Production"
    Purpose     = "Logging"
  }
}

# Block public access on logging bucket
resource "aws_s3_bucket_public_access_block" "data_lake_logs" {
  bucket                  = aws_s3_bucket.data_lake_logs.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Block all public access on main bucket
resource "aws_s3_bucket_public_access_block" "data_lake" {
  bucket                  = aws_s3_bucket.data_lake.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable encryption (SSE-S3 / AES256)
resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
  }
}

# Access logging
resource "aws_s3_bucket_logging" "data_lake" {
  bucket        = aws_s3_bucket.data_lake.id
  target_bucket = aws_s3_bucket.data_lake_logs.id
  target_prefix = "s3-access-logs/"
}
