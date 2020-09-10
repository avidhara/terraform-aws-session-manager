
output "cloudwatch_log_group_arn" {
  value = aws_cloudwatch_log_group.session_manager_log_group.arn
}

output "ssm_kms_key_arn" {
  description = "KMS key used for SSM"
  value       = module.kms.arn
}

output "ssm_cloudwatch_log_group_arn" {
  description = "The Amazon Resource Name (ARN) specifying the log group for SSM"
  value       = join("", aws_cloudwatch_log_group.session_manager_log_group.*.arn)
}

output "ssm_role_arn" {
  value = aws_iam_role.ssm_role.arn
}
