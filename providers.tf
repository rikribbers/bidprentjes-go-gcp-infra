terraform {
  required_version = "~> 1.10"
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
  project = "willyribbers-bidprentjes-go"
  region  = "europe-west4"
} 