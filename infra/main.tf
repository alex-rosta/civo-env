data "http" "my_ip" {
  url = "https://api.ipify.org?format=text"
}

resource "civo_firewall" "civo-fw" {
  name                 = "civo-fw"
  create_default_rules = false
  ingress_rule {
    label      = "https"
    protocol   = "tcp"
    port_range = "443"
    cidr       = ["0.0.0.0"]
    action     = "allow"
  }
  ingress_rule {
    label      = "kubectl"
    protocol   = "tcp"
    port_range = "6443"
    cidr       = ["${data.http.my_ip.response_body}/32"]
    action     = "allow"
  }
  egress_rule {
    label      = "allow-all-tcp"
    protocol   = "tcp"
    port_range = "0-65535"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
  egress_rule {
    label      = "allow-all-udp"
    protocol   = "udp"
    port_range = "0-65535"
    cidr       = ["0.0.0.0/0"]
    action     = "allow"
  }
}

# Deploy the Kubernetes cluster
module "kubernetes_cluster" {
  source       = "../modules/cluster"
  cluster_name = var.cluster_name
  node_size    = var.node_size
  node_count   = var.node_count
  applications = var.applications
  firewall_id  = civo_firewall.civo-fw.id
}

resource "local_file" "kubeconfig" {
  content  = module.kubernetes_cluster.kubeconfig
  filename = "${path.module}/kubeconfig"

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
