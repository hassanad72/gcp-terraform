variable "service_accounts" {
  description = "Service accounts to create"

  type = map(object({
    account_id   = string
    display_name = string
  }))
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "iam_binding" {
  description = "IAM roles to assign to service accounts"

  type = map(object({
    service_account = string
    role            = string
  }))

  validation {
    condition = alltrue([
      for binding in values(var.iam_binding) : startswith(binding.role, "roles/")
    ])
    error_message = "Each IAM role must begin with roles/."
  }
}
