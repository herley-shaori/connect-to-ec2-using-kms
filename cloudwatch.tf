# CloudWatch Log Group
resource "aws_cloudwatch_log_group" "log_group" {
  name              = "/aws/ec2/instance/logs"
  retention_in_days = 1
}

# CloudWatch Log Stream
resource "aws_cloudwatch_log_stream" "log_stream" {
  name           = "ec2-instance-log-stream"
  log_group_name = aws_cloudwatch_log_group.log_group.name
}

# Cloudwatch for SSM.
resource "aws_cloudwatch_log_group" "session_manager_logs" {
  name              = "/aws/ssm/session-manager"
  retention_in_days = 30

  kms_key_id = aws_kms_key.ssm_key.arn
}
