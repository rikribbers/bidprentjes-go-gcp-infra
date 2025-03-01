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
          memory = "2048Mi" # 2GB memory
        }
        cpu_idle = true # Enable CPU throttling when idle
      }

      env {
        name  = "STORAGE_BUCKET"
        value = google_storage_bucket.app_bucket.name
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }
}

# Create the storage bucket
resource "google_storage_bucket" "app_bucket" {
  name                        = "bidprentjes-go-storage"
  location                    = "europe-west4"
  uniform_bucket_level_access = true
}

# Grant the service account access to the bucket
resource "google_storage_bucket_iam_member" "bucket_access" {
  bucket = google_storage_bucket.app_bucket.name
  role   = "roles/storage.objectUser" # Changed from objectViewer to objectUser for read-write access
  member = "serviceAccount:${google_service_account.cloudrun_sa.email}"
}

# Make the service public
resource "google_cloud_run_v2_service_iam_member" "public" {
  name     = google_cloud_run_v2_service.default.name
  location = google_cloud_run_v2_service.default.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Output the service URL
output "service_url" {
  value = google_cloud_run_v2_service.default.uri
}

# Add bucket name to outputs
output "bucket_name" {
  value = google_storage_bucket.app_bucket.name
}
