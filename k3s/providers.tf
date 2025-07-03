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
  backend "s3" {
    endpoints = {
      s3 = var.s3_endpoint
    }
    key                      = "k3s/terraform.tfstate"
    bucket = var.s3_bucket_name
    region = "auto"
    access_key = var.cf_access_key
    secret_key = var.cf_secret_key
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_s3_checksum            = true
    use_path_style              = true
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