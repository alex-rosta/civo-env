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
