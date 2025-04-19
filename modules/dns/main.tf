terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

variable "cloudflare_email" {
  description = "Cloudflare account email"
  type        = string
  sensitive   = true

}

variable "cloudflare_api_key" {
  description = "Cloudflare API key"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare zone ID"
  type        = string
  sensitive   = true
}

variable "content" {
  description = "Content of the DNS record (IP address)"

}

variable "name" {
  description = "Name of the DNS record"
  type        = string

}

resource "cloudflare_dns_record" "a_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.name
  type    = "A"
  proxied = false
  ttl     = 1
  content = var.content
}