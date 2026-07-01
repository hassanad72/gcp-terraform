variable "project_id" {
  description = "Isolated GCP project used by Terratest"
  type        = string
}

variable "region" {
  description = "GCP region used by Terratest"
  type        = string
}

variable "test_id" {
  description = "Unique identifier appended to test resources"
  type        = string
}
