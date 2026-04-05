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

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for the domain"
  type        = string
}

variable "domain_name" {
  description = "The main domain name (e.g., rikribbers.nl)"
  type        = string
}

variable "photos_bucket_name" {
  description = "Name of the public GCS bucket for photos"
  type        = string
  default     = "photos"
}

variable "cdn_subdomain" {
  description = "Subdomain for the CDN"
  type        = string
  default     = "cdn"
}
