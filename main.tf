module "kms" {
  source                  = "app.terraform.io/foss-cafe/kms/aws"
  version                 = "1.0.0"
  enabled                 = true
  name                    = lookup(var.kms_key, "name")
  description             = lookup(var.kms_key, "description", "CMK for cloudwath logs and session")
  policy                  = data.aws_iam_policy_document.kms_access.json
  deletion_window_in_days = lookup(var.kms_key, "deletion_window_in_days", 7)
  tags                    = var.tags

}

resource "aws_cloudwatch_log_group" "session_manager_log_group" {
  count             = var.enable_log_to_cloudwatch ? 1 : 0
  name              = var.cloudwatch_log_group_name
  retention_in_days = var.cloudwatch_logs_retention
  kms_key_id        = module.kms.arn

  tags = var.tags
}
#### This Document is not working as expected need rework
# resource "aws_ssm_document" "session_manager_prefs" {
#   count = var.create_ssm_document ? 1: 0
#   name            = "SSM-SessionManagerRunShell"
#   document_type   = "Session"
#   document_format = "JSON"
#   tags            = var.tags

#   content = <<DOC
# {
#   "schemaVersion": "1.0",
#   "description": "Document to hold regional settings for Session Manager",
#   "sessionType": "Standard_Stream",
#   "inputs": {
#     "s3BucketName": "",
#     "s3KeyPrefix": "",
#     "s3EncryptionEnabled": true,
#     "cloudWatchLogGroupName": "${var.enable_log_to_cloudwatch ? var.cloudwatch_log_group_name : ""}",
#     "cloudWatchEncryptionEnabled": "${var.enable_log_to_cloudwatch ? "true" : "false"}",
#     "kmsKeyId": "${module.kms.key_id}",
#     "runAsEnabled": "false",
#     "runAsDefaultUser": ""
#   }
# }
# DOC
# }


# Create EC2 Instance Role for SSM
resource "aws_iam_role" "ssm_role" {
  name = "SessionManagerRole"
  path = "/"
  tags = var.tags

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
}



resource "aws_iam_policy" "ssm_s3_cwl_access" {
  name   = "SessionManagerPermissions"
  path   = "/"
  policy = data.aws_iam_policy_document.ssm_s3_cwl_access.json
}

resource "aws_iam_role_policy_attachment" "SSM_role_managed_instace_policy_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.AmazonSSMManagedInstanceCore.arn
}

resource "aws_iam_role_policy_attachment" "SSM_role_for_ec2_policy_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = data.aws_iam_policy.AmazonEC2RoleforSSM.arn
}

resource "aws_iam_role_policy_attachment" "SSM_s3_cwl_policy_attach" {
  role       = aws_iam_role.ssm_role.name
  policy_arn = aws_iam_policy.ssm_s3_cwl_access.arn
}

resource "aws_iam_instance_profile" "ssm_profile" {
  name = "ssm_profile"
  role = aws_iam_role.ssm_role.name
}
