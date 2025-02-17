terraform {
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
  }
}

resource "random_pet" "pet_name" {
  length = 2
}

output "pet_name" {
  value = random_pet.pet_name.id
} 