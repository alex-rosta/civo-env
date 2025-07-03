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

variable "s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "terraform-state"
}

variable "s3_bucket_name" {
  description = "S3 bucket name for Terraform state"
  type        = string
  default     = "terraform-state"
}

variable "s3_endpoint" {
  description = "S3 endpoint for Terraform state"
  type        = string
  sensitive = true
}

variable "cf_access_key" {
  description = "Cloudflare access key for S3 backend"
  type        = string
  sensitive   = true
}

variable "cf_secret_key" {
  description = "Cloudflare secret key for S3 backend"
  type        = string
  sensitive   = true
}

