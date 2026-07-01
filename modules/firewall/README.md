# Firewall Module

Creates Google Cloud VPC firewall rules for a supplied network.

## Requirements

- Terraform 1.5 or newer
- Google provider `~> 6.0`

## Usage

```hcl
module "firewall" {
  source  = "../../modules/firewall"
  network = module.network.network_name

  rules = {
    allow_ssh_iap = {
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["35.235.240.0/20"]
      protocol      = "tcp"
      ports         = ["22"]
      target_tags   = ["ssh"]
    }
  }
}
```

## Inputs

| Name | Description | Type | Required |
| --- | --- | --- | --- |
| `network` | VPC network ID or self-link | `string` | Yes |
| `rules` | Firewall rules keyed by rule name | `map(object)` | Yes |

Each rule supports direction, priority, source or destination ranges, protocol,
ports, target tags, and optional logging settings.

## Outputs

| Name | Description |
| --- | --- |
| `firewall_rule_names` | Names of the created firewall rules |
| `firewall_rule_ids` | Firewall rule IDs keyed by rule name |

## Guardrails

- Only `INGRESS` and `EGRESS` directions are accepted.
- INGRESS rules require source ranges and cannot use destination ranges.
- EGRESS rules require destination ranges and cannot use source ranges.
- Priorities must be between `0` and `65535`.
- Firewall logging is enabled by default without metadata.
- This module currently creates allow rules only.
