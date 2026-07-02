variable "network" {
  description = "VPC network ID or self-link"
  type        = string
}

variable "rules" {
  description = "Firewall rules keyed by their GCP rule name"
  type = map(object({
    name               = string
    direction          = string
    priority           = number
    source_ranges      = optional(list(string), [])
    destination_ranges = optional(list(string), [])
    protocol           = string
    ports              = list(string)
    target_tags        = list(string)
    logging_enabled    = optional(bool, true)
    logging_metadata   = optional(string, "EXCLUDE_ALL_METADATA")
  }))

  validation {
    condition = alltrue([
      for rule in values(var.rules) : contains(["INGRESS", "EGRESS"], rule.direction)
    ])
    error_message = "Each firewall rule direction must be either INGRESS or EGRESS."
  }

  validation {
    condition = alltrue([
      for rule in values(var.rules) : rule.priority >= 0 && rule.priority <= 65535
    ])
    error_message = "Each firewall rule priority must be between 0 and 65535."
  }

  validation {
    condition = alltrue([
      for rule in values(var.rules) :
      rule.direction != "INGRESS" || (
        length(rule.source_ranges) > 0 && length(rule.destination_ranges) == 0
      )
    ])
    error_message = "INGRESS firewall rules require source_ranges and cannot set destination_ranges."
  }

  validation {
    condition = alltrue([
      for rule in values(var.rules) :
      rule.direction != "EGRESS" || (
        length(rule.source_ranges) == 0 && length(rule.destination_ranges) > 0
      )
    ])
    error_message = "EGRESS firewall rules require destination_ranges and cannot set source_ranges."
  }

  validation {
    condition = alltrue([
      for rule in values(var.rules) :
      contains(["EXCLUDE_ALL_METADATA", "INCLUDE_ALL_METADATA"], rule.logging_metadata)
    ])
    error_message = "logging_metadata must be either EXCLUDE_ALL_METADATA or INCLUDE_ALL_METADATA."
  }
}
