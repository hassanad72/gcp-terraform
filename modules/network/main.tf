resource "google_compute_network" "ps_network" {
  name                    = var.network_name
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode

  delete_default_routes_on_create = var.delete_default_routes
}

resource "google_compute_subnetwork" "ps_subnet" {
  for_each = var.subnets

  name                     = each.value.name
  ip_cidr_range            = each.value.ip_cidr_range
  region                   = each.value.region
  network                  = google_compute_network.ps_network.id
  private_ip_google_access = each.value.private_ip_google_access
}
