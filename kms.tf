resource "aws_kms_key" "ssm_key" {
  description = "KMS key for SSM"
  deletion_window_in_days = 10
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow Session Manager to use the key"
        Effect = "Allow"
        Principal = {
          Service = "ssm.amazonaws.com"
        }
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ]
        Resource = "*"
      },
      {
        Sid    = "Allow Cloudwatch Logs to Use KMS"
        Effect = "Allow"
        Principal = {
          Service = "logs.amazonaws.com"
        }
        Action = [
          "kms:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kms_key" "s3_key" {
  description = "KMS key for S3"
  deletion_window_in_days = 10
}

resource "aws_kms_alias" "ssm_alias" {
  name          = "alias/ssm-key"
  target_key_id = aws_kms_key.ssm_key.key_id
}

resource "aws_kms_alias" "s3_alias" {
  name          = "alias/s3-key"
  target_key_id = aws_kms_key.s3_key.key_id
}

data "aws_caller_identity" "current" {}