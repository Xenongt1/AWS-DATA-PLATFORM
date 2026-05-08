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

# Block all public access
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

# Enable encryption (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
    bucket_key_enabled = true
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

# Enable logging on main bucket
resource "aws_s3_bucket_logging" "data_lake" {
  bucket        = aws_s3_bucket.data_lake.id
  target_bucket = aws_s3_bucket.data_lake_logs.id
  target_prefix = "s3-access-logs/"
}

# Lifecycle Policies
resource "aws_s3_bucket_lifecycle_configuration" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  rule {
    id     = "archive-processed-data-after-90-days"
    status = "Enabled"

    filter {
      prefix = "processed/"
    }

    transition {
      days          = 90
      storage_class = "GLACIER_IR"
    }

    transition {
      days          = 180
      storage_class = "DEEP_ARCHIVE"
    }
  }

  rule {
    id     = "delete-temp-data-after-1-day"
    status = "Enabled"

    filter {
      prefix = "temp/"
    }

    expiration {
      days = 1
    }
  }

  rule {
    id     = "archive-and-delete-after-7-years"
    status = "Enabled"

    filter {
      prefix = "archive/"
    }

    transition {
      days          = 1
      storage_class = "GLACIER_IR"
    }

    transition {
      days          = 91
      storage_class = "DEEP_ARCHIVE"
    }

    expiration {
      days = 2555
    }
  }
}

# Bucket Policy
resource "aws_s3_bucket_policy" "data_lake" {
  bucket = aws_s3_bucket.data_lake.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "EnforceSSLOnly"
        Effect    = "Deny"
        Principal = "*"
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*"
        ]
        Condition = {
          Bool = {
            "aws:SecureTransport" = "false"
          }
        }
      },
      {
        Sid    = "DenyUnencryptedObjectUploads"
        Effect = "Deny"
        Principal = "*"
        Action    = "s3:PutObject"
        Resource  = "${aws_s3_bucket.data_lake.arn}/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "AES256"
            "aws:PrincipalArn" = aws_iam_role.datasync_role.arn
          }
        }
      },
      {
        Sid    = "AllowRootAccess"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::899957567386:root"
        }
        Action = "s3:*"
        Resource = [
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*"
        ]
      },
      {
        Sid    = "AllowDataEngineerRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.data_engineer_role.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*"
        ]
      },
      {
        Sid    = "AllowGlueServiceRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.glue_service_role.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*"
        ]
      },
      {
        Sid    = "AllowRedshiftRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.redshift_iam_role.arn
        }
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*"
        ]
      },
      {
        Sid    = "AllowDataSyncRole"
        Effect = "Allow"
        Principal = {
          AWS = aws_iam_role.datasync_role.arn
        }
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = [
          aws_s3_bucket.data_lake.arn,
          "${aws_s3_bucket.data_lake.arn}/*"
        ]
      }
    ]
  })
}
