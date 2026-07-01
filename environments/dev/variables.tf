variable "project_id" {
  description = "GCP project ID for the development environment"
  type        = string
}

variable "region" {
  description = "Default GCP region for the development environment"
  type        = string
}

variable "environment" {
  description = "Short environment name used in resource naming"
  type        = string

  validation {
    condition     = var.environment == "dev"
    error_message = "The development root must use environment = \"dev\"."
  }
}
