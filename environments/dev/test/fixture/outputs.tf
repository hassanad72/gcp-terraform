output "network_id" {
  description = "ID of the temporary Terratest VPC"
  value       = module.network.network_id
}

output "bucket_names" {
  description = "Temporary Terratest bucket names keyed by logical name"
  value       = module.storage.bucket_names
}
