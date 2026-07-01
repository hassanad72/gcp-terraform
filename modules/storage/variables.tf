variable "buckets" {
  description = "Cloud Storage buckets keyed by stable logical identifiers"

  type = map(object({
    name                        = string
    location                    = string
    storage_class               = string
    uniform_bucket_level_access = bool
    public_access_prevention    = optional(string, "enforced")
    versioning_enabled          = bool
    force_destroy               = bool
  }))

  validation {
    condition = alltrue([
      for bucket in values(var.buckets) :
      contains(["enforced", "inherited"], bucket.public_access_prevention)
    ])
    error_message = "public_access_prevention must be either enforced or inherited."
  }
}

variable "bucket_iam_members" {
  description = "Bucket-level IAM memberships keyed by stable logical identifiers"

  type = map(object({
    bucket_key = string
    role       = string
    member     = string
  }))

  default = {}


}
