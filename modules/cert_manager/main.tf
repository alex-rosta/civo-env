# Reusable cert-manager ClusterIssuer module
terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

variable "name" {
  description = "Name of the ClusterIssuer"
  type        = string
  default     = "letsencrypt-prod"
}

variable "email" {
  description = "Email address for Let's Encrypt"
  type        = string
}

variable "server" {
  description = "ACME server URL"
  type        = string
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "ingress_class" {
  description = "Ingress class to use for HTTP01 solver"
  type        = string
  default     = "nginx"
}

# Kubernetes cert-manager ClusterIssuer resource
resource "kubernetes_manifest" "cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = var.name
    }
    spec = {
      acme = {
        server = var.server
        email  = var.email
        privateKeySecretRef = {
          name = var.name
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = var.ingress_class
              }
            }
          }
        ]
      }
    }
  }
}

output "issuer_name" {
  value = var.name
}
