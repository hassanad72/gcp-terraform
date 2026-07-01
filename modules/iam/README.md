# IAM Module

Creates Google Cloud service accounts and assigns project-level IAM roles to
them.

## Requirements

- Terraform 1.5 or newer
- Google provider `~> 6.0`

## Usage

```hcl
module "iam" {
  source     = "../../modules/iam"
  project_id = var.project_id

  service_accounts = {
    platform = {
      account_id   = "dev-platform-sa"
      display_name = "Development platform service account"
    }
  }

  iam_binding = {
    logging = {
      service_account = "platform"
      role            = "roles/logging.logWriter"
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
| --- | --- | --- | --- |
| `project_id` | GCP project ID | `string` | Yes |
| `service_accounts` | Service accounts keyed by a stable logical name | `map(object)` | Yes |
| `iam_binding` | Project roles assigned to service accounts | `map(object)` | Yes |

Each IAM binding references a key from `service_accounts` and a predefined role
that begins with `roles/`.

## Outputs

| Name | Description |
| --- | --- |
| `service_account_emails` | Service account emails keyed by logical name |
| `service_accounts_id` | Service account IDs keyed by logical name |

## Security Notes

- Grant only the roles required by each workload.
- IAM bindings created by this module apply across the project.
- Use resource-level IAM modules when access should be limited to one resource.
- This module currently supports predefined roles beginning with `roles/`.
