output "cloudsql-instance-name" {
  value = google_sql_database_instance.postgres_cloudsql_instance.name
}

output "cloudsql-connection-name" {
  description = "The connection name of the master instance to be used in connection strings"
  value = google_sql_database_instance.postgres_cloudsql_instance.connection_name
}

output "cloudsql-private-ip" {
  value       = google_sql_database_instance.postgres_cloudsql_instance.private_ip_address
  description = "The private IP address of the main SQL server instance."
}