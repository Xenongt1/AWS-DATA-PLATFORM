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
