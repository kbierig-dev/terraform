# Example Module - S3 Bucket

This module provisions a secure S3 bucket with public access blocked by default.

## Usage

```hcl
module "s3_bucket" {
  source      = "../../modules/example_module"
  bucket_name = "my-unique-bucket-name"
  environment = "prod"
}
```

## Testing

### Native Tests
This module uses Terraform 1.6+ native tests for validation. Run them with:
```bash
terraform test
```

### Integration Tests
Integration tests are located in the root `test/` directory using Terratest.

<!-- BEGIN_TF_DOCS -->
## Requirements
| Name | Version |
|------|---------|
| terraform | >= 1.6.0 |
| aws | >= 5.0 |

## Providers
| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_name | The name of the bucket to create. | `string` | n/a | yes |
| environment | The environment name for tagging. | `string` | `"dev"` | no |

## Outputs
| Name | Description |
|------|-------------|
| bucket\_arn | The ARN of the created S3 bucket. |
| bucket\_name | The name of the created S3 bucket. |
<!-- END_TF_DOCS -->
