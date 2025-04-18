# Reusable Kubernetes cluster module
terraform {
  required_providers {
    civo = {
      source = "civo/civo"
    }
  }
}

variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "node_size" {
  description = "Size of the Kubernetes nodes"
  type        = string
}

variable "node_count" {
  description = "Number of nodes in the cluster"
  type        = number
}

variable "applications" {
  description = "List of applications to install on the cluster"
  type        = string
}

variable "firewall_id" {
  description = "ID of the firewall to use"
  type        = string
}

# Civo Kubernetes cluster
resource "civo_kubernetes_cluster" "cluster" {
  firewall_id  = var.firewall_id
  name         = var.cluster_name
  applications = var.applications
  pools {
    label      = "${var.cluster_name}-pool"
    size       = var.node_size
    node_count = var.node_count
  }
}

# Generate kubeconfig file
resource "local_file" "kubeconfig" {
  filename = "${path.root}/k3s/kubeconfig"
  content  = civo_kubernetes_cluster.cluster.kubeconfig
}

output "kubeconfig" {
  value     = civo_kubernetes_cluster.cluster.kubeconfig
  sensitive = true
}

output "cluster_id" {
  value       = civo_kubernetes_cluster.cluster.id
  description = "ID of the created Kubernetes cluster"
}

output "api_endpoint" {
  value       = civo_kubernetes_cluster.cluster.api_endpoint
  description = "API endpoint of the Kubernetes cluster"
}

output "cluster_name" {
  value       = civo_kubernetes_cluster.cluster.name
  description = "Name of the Kubernetes cluster"
}
