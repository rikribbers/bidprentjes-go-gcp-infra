# Create a service account for Cloud Run
resource "google_service_account" "cloudrun_sa" {
  account_id   = "cloudrun-storage-sa"
  display_name = "Service Account for Cloud Run to access Storage"
}

# Update the Cloud Run service to use the service account
resource "google_cloud_run_v2_service" "default" {
  name     = "bidprentjes-go"
  location = "europe-west4"

  template {
    service_account = google_service_account.cloudrun_sa.email
    containers {
      image = "${var.app_image}:${var.app_version}"

      resources {
        limits = {
          cpu    = "1000m"  # 1 vCPU
          memory = "1536Mi" # 1.5GB memory
        }
        cpu_idle = true # Enable CPU throttling when idle
      }

      env {
        name  = "STORAGE_BUCKET"
        value = google_storage_bucket.app_bucket.name
      }

      env {
        name  = "GIN_MODE"
        value = "release"
      }
      env {
        name  = "CDN_BASE_URL"
        value = "${var.cdn_subdomain}.${var.domain_name}"
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }
}

# Create the original storage bucket (private for Cloud Run)
resource "google_storage_bucket" "app_bucket" {
  name                        = "bidprentjes-go-storage"
  location                    = "europe-west4"
  uniform_bucket_level_access = true
}

# Grant the service account access to the original bucket
resource "google_storage_bucket_iam_member" "bucket_access" {
  bucket = google_storage_bucket.app_bucket.name
  role   = "roles/storage.objectUser"
  member = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

# Make the service public
resource "google_cloud_run_v2_service_iam_member" "public" {
  name     = google_cloud_run_v2_service.default.name
  location = google_cloud_run_v2_service.default.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# New public storage bucket for photos
resource "google_storage_bucket" "photos_bucket" {
  name                        = "${var.cdn_subdomain}.${var.domain_name}"
  location                    = "europe-west4"
  uniform_bucket_level_access = true

  cors {
    origin          = ["https://${var.domain_name}", "https://www.${var.domain_name}"]
    method          = ["GET", "HEAD"]
    response_header = ["*"]
    max_age_seconds = 3600
  }
}

# Grant public read access to the photos bucket
resource "google_storage_bucket_iam_member" "photos_public_viewer" {
  bucket = google_storage_bucket.photos_bucket.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}

# Output for the Cloud Run service URL
output "service_url" {
  value = google_cloud_run_v2_service.default.uri
}

# Output for the original bucket name
output "app_bucket_name" {
  value = google_storage_bucket.app_bucket.name
}

# Output for the CDN URL
output "cdn_url" {
  value = "https://${var.cdn_subdomain}.${var.domain_name}"
}
