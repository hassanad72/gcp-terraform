output "firewall_rule_names" {
  value = keys(google_compute_firewall.rules)
}

output "firewall_rule_ids" {
  value = {
    for key, rule in google_compute_firewall.rules :
    key => rule.id
  }
}