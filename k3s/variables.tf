variable "domain" {
  description = "Base domain for ingress resources"
  type        = string
  default     = "rosta.dev"
}

variable "email" {
  description = "Email for Let's Encrypt"
  type        = string
  default     = "alex@rosta.dev"
}

variable "issuer_name" {
  description = "Name of the cert-manager ClusterIssuer"
  type        = string
  default     = "letsencrypt-prod"
}

provider "cloudflare" {
  email = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

variable "cloudflare_email" {
  description = "Cloudflare account email"
  type        = string
  sensitive = true
  
}

variable "cloudflare_api_key" {
  description = "Cloudflare API key"
  type        = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  type        = string
  sensitive = true
}

