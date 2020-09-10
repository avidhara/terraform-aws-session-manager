# Terraform AWS Session Manager Resources

## Use as a Module

```hcl
module "ssm_resources" {
    source = "./"
    kms_key = {
    name                    = "ssm-cmk-key"
    description             = "CMK for cloudwath logs and session"
    deletion_window_in_days = 7
  }
  cloudwatch_log_group_name =  "/ssm/session-logs"
  enable_log_to_cloudwatch = true
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.12.24 |
| aws | ~> 2.60 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.60 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cloudwatch\_log\_group\_name | Name of the CloudWatch Log Group for storing SSM Session Logs | `string` | `"/ssm/session-logs"` | no |
| cloudwatch\_logs\_retention | Number of days to retain Session Logs in CloudWatch | `number` | `30` | no |
| create\_ssm\_document | Do you want to create SSM Document | `bool` | `true` | no |
| default\_user | operating system user name for starting sessions | `string` | `"ec2-user"` | no |
| enable\_log\_to\_cloudwatch | Enable Session Manager to Log to CloudWatch Logs | `bool` | `true` | no |
| kms\_key | KMS Key Details | `map(string)` | <pre>{<br>  "deletion_window_in_days": 7,<br>  "description": "CMK for cloudwath logs and session",<br>  "name": "ssm-cmk-key"<br>}</pre> | no |
| run\_as\_enabled | Do you want to use Specify Operating System user for sessions | `bool` | `true` | no |
| tags | A map of tags to add to all resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| ssm\_cloudwatch\_log\_group\_arn | The Amazon Resource Name (ARN) specifying the log group for SSM |
| ssm\_kms\_key\_arn | KMS key used for SSM |
| ssm\_role\_arn | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
