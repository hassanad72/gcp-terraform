output "network_id" {
  description = "ID of the development VPC"
  value       = module.network.network_id
}

output "subnet_ids" {
  description = "Development subnet IDs keyed by logical name"
  value       = module.network.subnet_ids
}

output "firewall_rule_names" {
  description = "Names of development firewall rules"
  value       = module.firewall.firewall_rule_names
}

output "service_account_emails" {
  description = "Development service-account emails keyed by logical name"
  value       = module.iam.service_account_emails
}

output "bucket_names" {
  description = "Development bucket names keyed by logical name"
  value       = module.storage.bucket_names
}
