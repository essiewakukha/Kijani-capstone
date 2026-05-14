terraform {
  required_version = ">= 1.5.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.27.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "kijani_staging" {
  metadata {
    name = "kijani-staging"

    labels = {
      environment = "staging"
      managed-by  = "terraform"
    }
  }
}