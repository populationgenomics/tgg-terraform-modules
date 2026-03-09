resource "google_compute_global_address" "postgres_network_ip_alloc" {
  count         = var.enable_private_network ? 1 : 0
  name          = "google-managed-services-${var.private_network_name}"
  project       = var.project
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.private_network_id
}

resource "google_service_networking_connection" "postgres_network_connection" {
  count                   = var.enable_private_network ? 1 : 0
  network                 = var.private_network_id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.postgres_network_ip_alloc[0].name]
}

locals {
  dependent_network = var.enable_private_network ? google_service_networking_connection.postgres_network_connection[0] : null
}

resource "google_sql_database_instance" "postgres_cloudsql_instance" {
  depends_on       = [local.dependent_network]
  database_version = var.database_version
  name             = var.instance_name

  settings {
    activation_policy = "ALWAYS"
    availability_type = var.availability_type

    backup_configuration {
      backup_retention_settings {
        retained_backups = "30"
        retention_unit   = "COUNT"
      }

      binary_log_enabled             = "false"
      enabled                        = var.backup_enabled
      point_in_time_recovery_enabled = "false"
      start_time                     = "00:00"
      transaction_log_retention_days = "7"
    }

    disk_autoresize       = "true"
    disk_autoresize_limit = "0"
    disk_type             = "PD_SSD"

    ip_configuration {
      ipv4_enabled    = "true"
      private_network = var.enable_private_network ? var.private_network_id : null
    }

    location_preference {
      zone = var.database_location
    }

    maintenance_window {
      day          = "7"
      hour         = "5"
      update_track = "stable"
    }

    # pricing_plan = "PER_USE"
    tier         = var.database_tier
    edition = "ENTERPRISE" # Change the edition
  }
}

resource "google_sql_user" "postgres_user" {
  name     = "postgres"
  instance = google_sql_database_instance.postgres_cloudsql_instance.name
  password = var.postgres_password
}
