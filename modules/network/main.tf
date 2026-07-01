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

resource "google_compute_router" "ps_router" {
  for_each = var.routers

  name    = each.value.name
  region  = each.value.region
  network = google_compute_network.ps_network.id
}

resource "google_compute_router_nat" "ps_router_nat" {
  for_each = var.router_nats

  name                               = each.value.name
  router                             = google_compute_router.ps_router[each.value.router].name
  region                             = google_compute_router.ps_router[each.value.router].region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
