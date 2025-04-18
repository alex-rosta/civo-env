# Reusable ingress module
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "name" {
  description = "Name of the ingress"
  type        = string
}

variable "namespace" {
  description = "Kubernetes namespace for the ingress"
  type        = string
}

variable "annotations" {
  description = "Annotations to add to ingress"
  type        = map(string)
  default     = {}
}

variable "host" {
  description = "Host for the ingress rule"
  type        = string
}

variable "service_name" {
  description = "Name of the backend service"
  type        = string
}

variable "service_port" {
  description = "Port of the backend service"
  type        = number
}

variable "path" {
  description = "Path for the ingress rule"
  type        = string
  default     = "/"
}

variable "path_type" {
  description = "Path type for ingress"
  type        = string
  default     = "Prefix"
}

variable "tls_secret_name" {
  description = "Name of the TLS secret"
  type        = string
}

# Kubernetes ingress resource
resource "kubernetes_manifest" "ingress" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name        = var.name
      namespace   = var.namespace
      annotations = var.annotations
    }
    spec = {
      rules = [
        {
          host = var.host
          http = {
            paths = [
              {
                path     = var.path
                pathType = var.path_type
                backend = {
                  service = {
                    name = var.service_name
                    port = {
                      number = var.service_port
                    }
                  }
                }
              }
            ]
          }
        }
      ]
      tls = [
        {
          hosts      = [var.host]
          secretName = var.tls_secret_name
        }
      ]
    }
  }
}
