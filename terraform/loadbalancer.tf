# 1. Zarezerwowanie stałego, globalnego adresu IP dla naszej strony
resource "google_compute_global_address" "website_ip" {
  name       = "website-lb-ip"
  depends_on = [google_project_service.compute_api]
}

resource "google_compute_backend_bucket" "static_frontend" {
  name        = "frontend-backend-bucket"
  description = "Contains static HTML/CSS/JS files"
  bucket_name = google_storage_bucket.website_bucket.name
  enable_cdn  = true
}

resource "google_compute_region_network_endpoint_group" "backend_neg" {
  name                  = "backend-serverless-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  
  cloud_run {
    service = google_cloudfunctions2_function.api_function.name
  }
  depends_on = [google_project_service.compute_api]
}

resource "google_compute_backend_service" "backend_api" {
  name                  = "backend-api-service"
  protocol              = "HTTP"
  port_name             = "http"
  load_balancing_scheme = "EXTERNAL"
  
  backend {
    group = google_compute_region_network_endpoint_group.backend_neg.id
  }
}

resource "google_compute_url_map" "website_url_map" {
  name            = "website-url-map"
  default_service = google_compute_backend_bucket.static_frontend.id

  host_rule {
    hosts        = ["*"]
    path_matcher = "allpaths"
  }

  path_matcher {
    name            = "allpaths"
    default_service = google_compute_backend_bucket.static_frontend.id

    path_rule {
      paths   = ["/api", "/api/*"]
      service = google_compute_backend_service.backend_api.id
    }
  }
}

resource "google_compute_target_http_proxy" "website_http_proxy" {
  name    = "website-http-proxy"
  url_map = google_compute_url_map.website_url_map.id
}

resource "google_compute_global_forwarding_rule" "default" {
  name                  = "website-forwarding-rule"
  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_http_proxy.website_http_proxy.id
  ip_address            = google_compute_global_address.website_ip.id
  port_range            = "80"
}