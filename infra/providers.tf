terraform {
  required_version = "~> 1.14"
  cloud {
    organization = "rikribbers"

    workspaces {
      name = "bidprentjes-go-gcp-infra"
    }
  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.1"
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 6"
    }
  }
}

provider "google" {
  project = var.gcp_project_name
  region  = var.gcp_default_region
} 