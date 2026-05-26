output "firestore_database_name" {
  description = "Name of Firestore DB"
  value       = google_firestore_database.database.name
}

output "project_id" {
  description = "Project ID"
  value       = var.project_id
}


output "api_url" {
  description = "Public URL for API (Cloud Functions V2)"
  value       = google_cloudfunctions2_function.api_function.service_config[0].uri
}


output "website_url" {
  description = "Public www site addresss"
  value       = "https://storage.googleapis.com/${google_storage_bucket.website_bucket.name}/index.html"
}


output "workload_identity_provider_name" {
  description = "WIF provider name"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}

output "github_service_account_email" {
  description = "Email to service account"
  value       = google_service_account.github_actions_sa.email
}

output "load_balancer_ip" {
  description = "Global IP address to Load Balancer"
  value       = google_compute_global_address.website_ip.address
}
