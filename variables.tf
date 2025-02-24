variable "app_version" {
  description = "The version tag for the bidprentjes-go container image"
  type        = string
  default     = "v0.0.2"
}

variable "app_image" {
  description = "The full path to the container image (without version)"
  type        = string
  default     = "docker.io/rikribbers/bidprentjes-go"
} 