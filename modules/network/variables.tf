variable "network_name" {
  description = "Name of the VPC Network"
  type        = string
}

variable "routing_mode" {
  description = "routing mode for the VPC"
  type        = string
  default     = "REGIONAL"
}

variable "subnets" {
  description = "Subnets to create, keyed by a stable logical identifier"
  type = map(object({
    name                     = string
    ip_cidr_range            = string
    region                   = string
    private_ip_google_access = bool
  }))
}


variable "delete_default_routes" {
  type    = bool
  default = false
}

variable "router" {
  description = "Cloud Router to create"
  type = object({
    name   = string
    region = string
  })
}

variable "router_nat" {
  description = "Cloud NAT gateway to create"
  type = object({
    name        = string
    subnet_keys = optional(set(string), [])
  })
}
