data "civo_firewall" "default" {
  name = "default-default"
}

resource "civo_kubernetes_cluster" "rsk3s" {
  firewall_id  = data.civo_firewall.default.id
  name         = "rsk3s-cluster"
  applications = "kubernetes-dashboard,helm,cert-manager,nginx"
  pools {
    label      = "rsk3s-pool"
    size       = "g4s.kube.medium"
    node_count = 2
  }

}

resource "local_file" "kubeconfig" {
  filename = "${path.module}/kubeconfig"
  content  = civo_kubernetes_cluster.rsk3s.kubeconfig

}
