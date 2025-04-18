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
