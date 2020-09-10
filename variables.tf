variable "kms_key" {
  type        = map(string)
  description = "KMS Key Details"
  default = {
    name                    = "ssm-cmk-key"
    description             = "CMK for cloudwath logs and session"
    deletion_window_in_days = 7
  }
}

variable "cloudwatch_logs_retention" {
  description = "Number of days to retain Session Logs in CloudWatch"
  type        = number
  default     = 30
}

variable "cloudwatch_log_group_name" {
  description = "Name of the CloudWatch Log Group for storing SSM Session Logs"
  type        = string
  default     = "/ssm/session-logs"
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

variable "enable_log_to_cloudwatch" {
  description = "Enable Session Manager to Log to CloudWatch Logs"
  type        = bool
  default     = true
}

variable "run_as_enabled" {
  type        = bool
  description = "Do you want to use Specify Operating System user for sessions"
  default     = true
}

variable "default_user" {
  type        = string
  description = "operating system user name for starting sessions"
  default     = "ec2-user"
}

variable "create_ssm_document" {
  type        = bool
  description = "Do you want to create SSM Document"
  default     = true
}
