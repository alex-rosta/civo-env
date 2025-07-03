variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "rsk3s-cluster"
}

variable "node_size" {
  description = "Size of the Kubernetes nodes"
  type        = string
  default     = "g4s.kube.medium"
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "applications" {
  description = "List of applications to install on the cluster"
  type        = string
  default     = "kubernetes-dashboard,helm,cert-manager,nginx,metrics-server,argocd"
}

variable "region" {
  description = "Civo region to deploy resources"
  type        = string
  default     = "FRA1"
}

variable "akeyless_access_id" {
  description = "Akeyless access ID"
  type        = string
  sensitive = true
}

variable "akeyless_access_key" {
  description = "Akeyless access key"
  type        = string
  sensitive = true
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
