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
