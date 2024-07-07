resource "aws_ssm_document" "session_manager_prefs" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = jsonencode({
    schemaVersion = "1.0"
    description   = "Document to hold Session Manager preferences"
    sessionType   = "Standard_Stream"
    inputs = {
      kmsKeyId                 = aws_kms_key.ssm_key.arn
      cloudWatchLogGroupName   = aws_cloudwatch_log_group.session_manager_logs.name
      cloudWatchEncryptionEnabled = true
      cloudWatchStreamingEnabled  = true
      idleSessionTimeout       = "20"
    }
  })
}
