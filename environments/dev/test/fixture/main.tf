locals {
  name_prefix = "tt-${var.test_id}"
}

module "network" {
  source = "../../../../modules/network"

  network_name          = "${local.name_prefix}-vpc"
  routing_mode          = "REGIONAL"
  delete_default_routes = false

  subnets = {
    application = {
      name                     = "${local.name_prefix}-subnet"
      ip_cidr_range            = "10.200.0.0/24"
      region                   = var.region
      private_ip_google_access = true
    }
  }

  router = {
    name   = "${local.name_prefix}-router"
    region = var.region
  }

  router_nat = {
    name        = "${local.name_prefix}-nat"
    subnet_keys = ["application"]
  }
}

module "firewall" {
  source  = "../../../../modules/firewall"
  network = module.network.network_name

  rules = {
    allow_ssh_iap = {
      name          = "${local.name_prefix}-allow-ssh-iap"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["35.235.240.0/20"]
      protocol      = "tcp"
      ports         = ["22"]
      target_tags   = ["ssh"]
    }
  }
}

module "iam" {
  source = "../../../../modules/iam"

  project_id = var.project_id

  service_accounts = {
    platform = {
      account_id   = "${local.name_prefix}-sa"
      display_name = "Terratest service account"
    }
  }

  iam_binding = {
    logging = {
      service_account = "platform"
      role            = "roles/logging.logWriter"
    }
  }
}

module "storage" {
  source = "../../../../modules/storage"

  buckets = {
    application = {
      name                        = "${var.project_id}-${local.name_prefix}-data"
      location                    = "US"
      storage_class               = "STANDARD"
      uniform_bucket_level_access = true
      public_access_prevention    = "enforced"
      versioning_enabled          = true
      force_destroy               = true
    }
  }

  bucket_iam_members = {
    platform_object_viewer = {
      bucket_key = "application"
      role       = "roles/storage.objectViewer"
      member     = "serviceAccount:${module.iam.service_account_emails["platform"]}"
    }
  }
}
