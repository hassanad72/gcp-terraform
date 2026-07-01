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

  routers = {
    primary = {
      name   = "example-dev-router"
      region = "us-central1"
    }
  }

  router_nats = {
    primary = {
      name   = "example-dev-nat"
      router = "primary"
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
| `routers` | Cloud Routers keyed by a stable logical name | `map(object)` | No | `{}` |
| `router_nats` | Cloud NAT gateways keyed by a stable logical name | `map(object)` | No | `{}` |

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
- Cloud NAT uses automatically allocated IP addresses and logs errors.
- Each configured NAT gateway serves all subnet IP ranges in its region.
- Deleting default routes requires replacement routing before workloads need
  outbound connectivity.
