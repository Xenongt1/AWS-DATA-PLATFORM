# AWS Data Platform

A production-grade AWS data platform built with Terraform, covering IAM security, networking, and S3 data lake foundation.

## Project Structure

```
aws-data-platform/
├── lab-1.1-iam-setup/           # IAM roles and policies for data engineering
├── lab-1.2-vpc-network/         # VPC, subnets, security groups, VPC endpoints
├── lab-1.3-s3-lake-formation/   # S3 data lake with encryption, versioning & lifecycle
├── lab-2.1-glue-catalog/        # AWS Glue catalog databases and crawlers
├── lab-2.2-datasync/            # DataSync batch ingestion with scheduled sync
├── lab-2.3-kinesis/             # Kinesis data streaming setup
└── lab-3.1-redshift/            # Redshift data warehouse cluster
```

## Tracked Labs (Submission)

### Lab 1.1 — IAM Setup for Data Engineering
Provisions all IAM roles and policies for the data platform:
- **DataEngineerRole** — S3, Glue, Redshift, Kinesis, Lambda, CloudWatch access
- **GlueServiceRole** — Service role for AWS Glue jobs
- **LambdaExecutionRole** — Lambda execution with S3, DynamoDB, Kinesis access
- **RedshiftIAMRole** — Redshift to S3 read/write access
- **AnalystReadOnlyRole** — Read-only access for data analysts
- **DataLakeBucketAccessPolicy** — Custom policy with encryption enforcement

### Lab 1.2 — VPC & Network Setup
Full network infrastructure for a secure data platform:
- VPC (`10.0.0.0/16`) with DNS enabled
- Public subnet (`10.0.1.0/24`) and two private subnets (`10.0.2.0/24`, `10.0.3.0/24`)
- Internet Gateway, public and private route tables
- Security groups: public NAT, private compute, private DB
- VPC Endpoints: S3 (Gateway), DynamoDB (Gateway), Secrets Manager (Interface)

### Lab 1.3 — S3 Lake Formation
Production-grade S3 data lake:
- Encrypted S3 bucket (SSE-S3/AES256) with versioning and access logging
- Bucket policy enforcing SSL-only access and encryption at rest
- IAM role allow statements for DataSync, Glue, Redshift, and Data Engineers
- Lifecycle rules: Glacier IR (90 days), Deep Archive (180 days), 7-year retention

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform >= 1.0
- AWS account with access to IAM, VPC, S3 services

## Usage

```bash
cd lab-1.1-iam-setup   # (or any lab folder)
terraform init
terraform plan
terraform apply
```

## Author
Mubarak Tijani  
mubarak.tijani@amalitechtraining.org
