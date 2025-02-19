resource "google_cloud_run_v2_service" "default" {
  name     = "bidprentjes-go"
  location = "europe-west4"

  template {
    containers {
      image = "docker.io/rikribbers/bidprentjes-go:latest"

      resources {
        limits = {
          cpu    = "1000m" # 1 vCPU
          memory = "512Mi" # Minimal memory
        }
        cpu_idle = true # Enable CPU throttling when idle
      }
    }
    scaling {
      min_instance_count = 0
      max_instance_count = 1
    }
  }
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
  value = google_cloud_run_v2_service.default.ur1
}
