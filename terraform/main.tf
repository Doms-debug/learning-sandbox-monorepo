terraform {
  backend "gcs" {
    bucket = "prj-cloud-sandbox-repo-tfstate"
    prefix = "terraform/state"
  }
}


resource "google_project_service" "firestore_api" {
  project            = var.project_id
  service            = "firestore.googleapis.com"
  disable_on_destroy = false
}


resource "google_firestore_database" "database" {
  project     = var.project_id
  name        = "(default)"
  location_id = var.region
  type        = "FIRESTORE_NATIVE"

  depends_on = [google_project_service.firestore_api]
}


resource "google_project_service" "cloudbuild_api" {
  project            = var.project_id
  service            = "cloudbuild.googleapis.com"
  disable_on_destroy = false
}


resource "google_project_service" "artifactregistry_api" {
  project            = var.project_id
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}


resource "google_project_service" "cloudfunctions_api" {
  project            = var.project_id
  service            = "cloudfunctions.googleapis.com"
  disable_on_destroy = false
}


resource "google_storage_bucket" "function_bucket" {
  name          = "${var.project_id}-cloud-functions-source"
  location      = var.region
  force_destroy = true
}


data "archive_file" "function_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../backend"
  output_path = "${path.module}/function.zip"
  excludes    = ["venv", "__pycache__", ".pytest_cache"]
}

resource "google_storage_bucket_object" "zip" {
  name   = "source-${data.archive_file.function_zip.output_md5}.zip"
  bucket = google_storage_bucket.function_bucket.name
  source = data.archive_file.function_zip.output_path
}


resource "google_service_account" "function_sa" {
  account_id   = "visitor-counter-sa"
  display_name = "Cloud Function Service Account"
}

resource "google_project_iam_member" "firestore_user" {
  project = var.project_id
  role    = "roles/datastore.user"
  member  = "serviceAccount:${google_service_account.function_sa.email}"
}


resource "google_project_service" "cloudrun_api" {
  project            = var.project_id
  service            = "run.googleapis.com"
  disable_on_destroy = false
}


resource "google_cloudfunctions2_function" "api_function" {
  name        = "visitor-counter-api"
  location    = var.region
  description = "Backend API for visitor counting (V2)"

  build_config {
    runtime     = "python311"
    entry_point = "update_counter"
    source {
      storage_source {
        bucket = google_storage_bucket.function_bucket.name
        object = google_storage_bucket_object.zip.name
      }
    }
  }

  service_config {
    max_instance_count    = 1
    available_memory      = "128Mi"
    timeout_seconds       = 60
    service_account_email = google_service_account.function_sa.email
  }

  depends_on = [
    google_project_service.cloudbuild_api,
    google_project_service.cloudfunctions_api,
    google_project_service.artifactregistry_api,
    google_project_service.cloudrun_api
  ]
}


resource "google_cloud_run_service_iam_member" "invoker" {
  project  = google_cloudfunctions2_function.api_function.project
  location = google_cloudfunctions2_function.api_function.location
  service  = google_cloudfunctions2_function.api_function.name
  role     = "roles/run.invoker"
  member   = "allUsers"
}



resource "google_storage_bucket" "website_bucket" {
  name          = "${var.project_id}-frontend-cv"
  location      = var.region
  force_destroy = true

  uniform_bucket_level_access = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}

resource "google_storage_bucket_iam_member" "public_read_website" {
  bucket = google_storage_bucket.website_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}


resource "google_storage_bucket_object" "frontend_files" {
  for_each = fileset("${path.module}/../frontend", "*")

  name   = each.value
  bucket = google_storage_bucket.website_bucket.name
  source = "${path.module}/../frontend/${each.value}"

  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}


resource "google_project_service" "iamcredentials_api" {
  project            = var.project_id
  service            = "iamcredentials.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "sts_api" {
  project            = var.project_id
  service            = "sts.googleapis.com"
  disable_on_destroy = false
}

resource "google_iam_workload_identity_pool" "github_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "github-actions-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Identity pool for automated deployments"

  depends_on = [google_project_service.iamcredentials_api]
}

resource "google_iam_workload_identity_pool_provider" "github_provider" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Provider"

  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }

  attribute_condition = "assertion.repository == \"Doms-debug/learning-sandbox-monorepo\""

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

resource "google_service_account" "github_actions_sa" {
  account_id   = "github-actions-deployer"
  display_name = "GitHub Actions Deployer SA"
}

resource "google_project_iam_member" "github_sa_owner" {
  project = var.project_id
  role    = "roles/owner"
  member  = "serviceAccount:${google_service_account.github_actions_sa.email}"
}

resource "google_service_account_iam_member" "workload_identity_user" {
  service_account_id = google_service_account.github_actions_sa.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/attribute.repository/Doms-debug/learning-sandbox-monorepo"
}
