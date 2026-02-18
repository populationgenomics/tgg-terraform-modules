output "cloudsql-instance-name" {
  value = google_sql_database_instance.postgres_cloudsql_instance.name
}

output "cloudsql-connection-name" {
  description = "The connection name of the master instance to be used in connection strings"
  value = google_sql_database_instance.postgres_cloudsql_instance.connection_name
}
