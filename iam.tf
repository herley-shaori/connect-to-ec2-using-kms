# IAM Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "sample_ssm_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }
    ]
  })
}

# Attach SSM Policy to IAM Role
resource "aws_iam_role_policy_attachment" "ssm_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "ssm_kms_policy" {
  name        = "SSM-KMS-Policy"
  description = "Policy to allow SSM to use KMS key"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = aws_kms_key.ssm_key.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_kms_policy_attachment" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ssm_kms_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "sample_ssm_instance_profile"
  role = aws_iam_role.ssm_role.name
}

data "aws_iam_policy_document" "session_manager_kms_policy" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:UpdateInstanceInformation",
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = [aws_kms_key.ssm_key.arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams"
    ]
    resources = ["arn:aws:logs:*:*:log-group:${aws_cloudwatch_log_group.session_manager_logs.name}:*"]
  }
}

resource "aws_iam_role_policy" "session_manager_kms_policy" {
  name   = "session-manager-kms-policy"
  role   = aws_iam_role.ssm_role.id
  policy = data.aws_iam_policy_document.session_manager_kms_policy.json
}
