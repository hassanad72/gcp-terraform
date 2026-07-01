# Network Module

Creates a custom Google Cloud VPC network and one or more regional subnets.

## Requirements

- Terraform 1.5 or newer
- Google provider `~> 6.0`

## Usage

```hcl
module "network" {
  source                = "../../modules/network"
  network_name          = "example-dev-vpc"
  routing_mode          = "REGIONAL"
  delete_default_routes = false

  subnets = {
    application = {
      name                     = "example-dev-app-subnet"
      ip_cidr_range            = "10.10.0.0/24"
      region                   = "us-central1"
      private_ip_google_access = true
    }
  }
}
```

## Inputs

| Name | Description | Type | Required | Default |
| --- | --- | --- | --- | --- |
| `network_name` | Name of the VPC network | `string` | Yes | — |
| `subnets` | Subnets keyed by a stable logical name | `map(object)` | Yes | — |
| `routing_mode` | VPC routing mode | `string` | No | `REGIONAL` |
| `delete_default_routes` | Delete automatically created default routes | `bool` | No | `false` |

## Outputs

| Name | Description |
| --- | --- |
| `network_id` | VPC network ID |
| `network_name` | VPC network name |
| `network_self_link` | VPC network self-link |
| `subnet_ids` | Subnet IDs keyed by logical name |
| `subnet_names` | Subnet names keyed by logical name |

## Network Notes

- Automatic subnet creation is disabled.
- CIDR ranges and regions are configured independently for each subnet.
- Private Google Access can be enabled per subnet.
- Deleting default routes requires replacement routing before workloads need
  outbound connectivity.
