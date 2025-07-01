terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    akeyless = {
      source = "akeyless-community/akeyless"
    }
  }
}

provider "akeyless" {
  api_gateway_address = "https://api.akeyless.io"
  api_key_login {
    access_id  = var.akeyless_access_id
    access_key = var.akeyless_access_key
  }
}

provider "kubernetes" {
  config_path = "../infra/kubeconfig"
}