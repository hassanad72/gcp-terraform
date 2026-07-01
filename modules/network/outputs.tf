output "network_id" {
  description = "ID of the VPC Network"
  value       = google_compute_network.ps_network.id
}

output "network_name" {
  description = "Name of the VPC network"
  value       = google_compute_network.ps_network.name
}

output "network_self_link" {
  description = "Self link of the VPC Network"
  value       = google_compute_network.ps_network.self_link
}

output "subnet_ids" {
  description = "Subnet IDs keyed by their stable logical identifiers"
  value = {
    for key, subnet in google_compute_subnetwork.ps_subnet : key => subnet.id
  }
}

output "subnet_names" {
  description = "Subnet names keyed by their stable logical identifiers"
  value = {
    for key, subnet in google_compute_subnetwork.ps_subnet : key => subnet.name
  }
}
