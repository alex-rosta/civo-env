# Get the default firewall
data "civo_firewall" "default" {
  name = "default-default"
}

# Deploy the Kubernetes cluster
module "kubernetes_cluster" {
  source        = "../modules/cluster"
  cluster_name  = var.cluster_name
  node_size     = var.node_size
  node_count    = var.node_count
  applications  = var.applications
  firewall_id   = data.civo_firewall.default.id
}

# Expose useful outputs
output "kubeconfig" {
  value     = module.kubernetes_cluster.kubeconfig
  sensitive = true
}

output "cluster_id" {
  value       = module.kubernetes_cluster.cluster_id
  description = "ID of the created Kubernetes cluster"
}

output "api_endpoint" {
  value       = module.kubernetes_cluster.api_endpoint
  description = "API endpoint of the Kubernetes cluster"
}

output "cluster_name" {
  value       = module.kubernetes_cluster.cluster_name
  description = "Name of the Kubernetes cluster"
}
