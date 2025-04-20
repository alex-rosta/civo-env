terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "kubernetes" {
  config_path = "../infra/kubeconfig"
}