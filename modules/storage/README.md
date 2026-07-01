# Storage Module

Creates Google Cloud Storage buckets and optional bucket-level IAM memberships.

## Requirements

- Terraform 1.5 or newer
- Google provider `~> 6.0`

## Usage

```hcl
module "storage" {
  source = "../../modules/storage"

  buckets = {
    application = {
      name                        = "example-dev-data"
      location                    = "US"
      storage_class               = "STANDARD"
      uniform_bucket_level_access = true
      public_access_prevention    = "enforced"
      versioning_enabled          = true
      force_destroy               = false
    }
  }

  bucket_iam_members = {
    application_viewer = {
      bucket_key = "application"
      role       = "roles/storage.objectViewer"
      member     = "serviceAccount:example@example-project.iam.gserviceaccount.com"
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
| --- | --- | --- | --- |
| `buckets` | Storage buckets keyed by a stable logical name | `map(object)` | Yes |
| `bucket_iam_members` | Bucket-level IAM memberships | `map(object)` | No |

Each bucket supports its name, location, storage class, uniform bucket-level
access, public access prevention, versioning, and force-destroy behavior.

## Outputs

| Name | Description |
| --- | --- |
| `bucket_names` | Bucket names keyed by logical name |
| `bucket_urls` | Bucket URLs keyed by logical name |

## Security Notes

- Public access prevention defaults to `enforced` when omitted.
- Use uniform bucket-level access to manage permissions through IAM.
- IAM roles are assigned to individual buckets rather than the whole project.
- Keep `force_destroy` set to `false` when bucket data must be protected.
- Enable versioning when previous object versions must be recoverable.
