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

output "router_id" {
  description = "Cloud Router ID"
  value       = google_compute_router.ps_router.id
}

output "router_name" {
  description = "Cloud Router name"
  value       = google_compute_router.ps_router.name
}

output "router_nat_id" {
  description = "Cloud NAT gateway ID"
  value       = google_compute_router_nat.ps_router_nat.id
}

output "router_nat_name" {
  description = "Cloud NAT gateway name"
  value       = google_compute_router_nat.ps_router_nat.name
}
