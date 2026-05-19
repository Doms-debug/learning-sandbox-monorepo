output "firestore_database_name" {
  description = "Name of Firestore DB"
  value       = google_firestore_database.database.name
}

output "project_id" {
  description = "Project ID"
  value       = var.project_id
}
