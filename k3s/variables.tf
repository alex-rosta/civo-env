variable "email" {
  description = "Email for Let's Encrypt"
  type        = string
  default     = "alex@rosta.dev"
}



variable "akeyless_access_id" {
  description = "Akeyless access ID"
  type        = string
  sensitive   = true
}

variable "akeyless_access_key" {
  description = "Akeyless access key"
  type        = string
  sensitive   = true
}


