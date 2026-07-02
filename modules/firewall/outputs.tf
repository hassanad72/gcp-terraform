output "firewall_rule_names" {
  value = {
    for key, rule in google_compute_firewall.rules :
    key => rule.name
  }
}

output "firewall_rule_ids" {
  value = {
    for key, rule in google_compute_firewall.rules :
    key => rule.id
  }
}