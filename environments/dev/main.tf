locals {
  name_prefix = "publicis-${var.environment}"
}

module "network" {
  source = "../../modules/network"

  network_name          = "${local.name_prefix}-vpc"
  routing_mode          = "REGIONAL"
  delete_default_routes = false

  subnets = {
    subnet_1 = {
      name                     = "${local.name_prefix}-subnet-1"
      ip_cidr_range            = "10.0.1.0/24"
      region                   = var.region
      private_ip_google_access = true
    }
    subnet_2 = {
      name                     = "${local.name_prefix}-subnet-2"
      ip_cidr_range            = "10.0.2.0/24"
      region                   = var.region
      private_ip_google_access = true
    }
    subnet_3 = {
      name                     = "${local.name_prefix}-subnet-3"
      ip_cidr_range            = "10.0.3.0/24"
      region                   = var.region
      private_ip_google_access = true
    }
  }

  router = {
    name   = "${local.name_prefix}-router-1"
    region = var.region
  }

  router_nat = {
    name        = "${local.name_prefix}-router-nat-1"
    subnet_keys = ["subnet_1", "subnet_3"]
  }
}


module "firewall" {
  source  = "../../modules/firewall"
  network = module.network.network_name

  rules = {
    allow-ssh-iap = {
      name          = "${local.name_prefix}-allow-ssh-iap"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["35.235.240.0/20"]
      protocol      = "tcp"
      ports         = ["22"]
      target_tags   = ["ssh"]
    }

    allow-web = {
      name          = "${local.name_prefix}-allow-web"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = ["0.0.0.0/0"]
      protocol      = "tcp"
      ports         = ["80", "443"]
      target_tags   = ["web"]
    }
  }

}

module "iam" {
  source = "../../modules/iam"

  project_id = var.project_id

  service_accounts = {
    platform = {
      account_id   = "${local.name_prefix}-sa"
      display_name = "Development platform service account"
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
  source = "../../modules/storage"

  buckets = {
    application = {
      name                        = "${local.name_prefix}-data"
      location                    = "US"
      storage_class               = "STANDARD"
      uniform_bucket_level_access = true
      public_access_prevention    = "enforced"
      versioning_enabled          = true
      force_destroy               = false
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
