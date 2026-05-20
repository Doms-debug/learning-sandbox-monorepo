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
