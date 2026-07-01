resource "google_compute_firewall" "rules" {
  for_each = var.rules

  name    = each.key
  network = var.network

  priority           = each.value.priority
  direction          = each.value.direction
  source_ranges      = each.value.direction == "INGRESS" ? each.value.source_ranges : null
  destination_ranges = each.value.direction == "EGRESS" ? each.value.destination_ranges : null
  target_tags        = each.value.target_tags

  dynamic "log_config" {
    for_each = each.value.logging_enabled ? [1] : []

    content {
      metadata = each.value.logging_metadata
    }
  }

  allow {
    protocol = each.value.protocol
    ports    = each.value.ports
  }
}
