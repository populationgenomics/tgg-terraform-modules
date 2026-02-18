output "gke-cluster-name" {
  value = google_container_cluster.cluster.name
}

# cluster API endpoint
output "gke_cluster_api_endpoint" {
  value = google_container_cluster.cluster.endpoint
}

# cluster CA certificate
output "gke_cluster_ca_cert" {
  value = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
}