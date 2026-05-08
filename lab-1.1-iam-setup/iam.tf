# ============================================
# LAB 1.1: IAM ROLES AND POLICIES
# ============================================

# Data Engineer Role
resource "aws_iam_role" "data_engineer_role" {
  name        = "DataEngineerRole-tf"
  description = "Role for data engineers to access S3, Glue, Redshift, EMR, Kinesis, Lambda, and CloudWatch"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "de_s3" {
  role       = aws_iam_role.data_engineer_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "de_glue" {
  role       = aws_iam_role.data_engineer_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSGlueConsoleFullAccess"
}

resource "aws_iam_role_policy_attachment" "de_redshift" {
  role       = aws_iam_role.data_engineer_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftFullAccess"
}

resource "aws_iam_role_policy_attachment" "de_kinesis" {
  role       = aws_iam_role.data_engineer_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

resource "aws_iam_role_policy_attachment" "de_lambda" {
  role       = aws_iam_role.data_engineer_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}

resource "aws_iam_role_policy_attachment" "de_cloudwatch" {
  role       = aws_iam_role.data_engineer_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Glue Service Role
resource "aws_iam_role" "glue_service_role" {
  name        = "GlueServiceRole-tf"
  description = "Service role for AWS Glue jobs"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "glue.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy_attachment" "glue_s3" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "glue_cloudwatch" {
  role       = aws_iam_role.glue_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Lambda Execution Role
resource "aws_iam_role" "lambda_execution_role" {
  name        = "LambdaExecutionRole-tf"
  description = "Execution role for Lambda functions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_dynamodb" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_kinesis" {
  role       = aws_iam_role.lambda_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKinesisFullAccess"
}

# Redshift IAM Role
resource "aws_iam_role" "redshift_iam_role" {
  name        = "RedshiftIAMRole-tf"
  description = "Service role for Redshift to read/write to S3"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "redshift.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_s3" {
  role       = aws_iam_role.redshift_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "redshift_cloudwatch" {
  role       = aws_iam_role.redshift_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# Analyst Read Only Role
resource "aws_iam_role" "analyst_readonly_role" {
  name        = "AnalystReadOnlyRole-tf"
  description = "Read-only role for analysts"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "analyst_athena" {
  role       = aws_iam_role.analyst_readonly_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAthenaFullAccess"
}

resource "aws_iam_role_policy_attachment" "analyst_redshift" {
  role       = aws_iam_role.analyst_readonly_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRedshiftReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "analyst_s3" {
  role       = aws_iam_role.analyst_readonly_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Custom Data Lake Policy
resource "aws_iam_policy" "data_lake_policy" {
  name        = "DataLakeBucketAccessPolicy-tf"
  description = "Custom policy for data lake S3 access with encryption enforcement"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListDataLakeBucket"
        Effect = "Allow"
        Action = ["s3:ListBucket", "s3:GetBucketLocation"]
        Resource = "arn:aws:s3:::data-lake-*"
      },
      {
        Sid    = "ReadWriteDataLakeObjects"
        Effect = "Allow"
        Action = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
        Resource = "arn:aws:s3:::data-lake-*/*"
      },
      {
        Sid    = "DenyUnencryptedUploads"
        Effect = "Deny"
        Action = "s3:PutObject"
        Resource = "arn:aws:s3:::data-lake-*/*"
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption" = "AES256"
          }
        }
      }
    ]
  })
}