variable "app_version" {
  description = "The version tag for the bidprentjes-go container image"
  type        = string
}

variable "app_image" {
  description = "The full path to the container image (without version)"
  type        = string
}

variable "gcp_project_name" {
  description = "The GCP project where to deploy the resources"
  type        = string
}

variable "gcp_default_region" {
  description = "The default GCP region where to deploy the resources"
  type        = string
}
