terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

provider "kubernetes" {
  config_path = "${path.module}/kubeconfig"
}

# Common ingress annotations
locals {
  common_ingress_annotations = {
    "kubernetes.io/ingress.class"    = "nginx"
    "cert-manager.io/cluster-issuer" = module.cert_manager.issuer_name
  }

  dashboard_annotations = merge(local.common_ingress_annotations, {
    "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
  })

  argocd_annotations = merge(local.common_ingress_annotations, {
    "nginx.ingress.kubernetes.io/ssl-passthrough"  = "true"
    "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
  })
}

# Deploy the cert-manager ClusterIssuer
module "cert_manager" {
  source        = "../modules/cert_manager"
  name          = var.issuer_name
  email         = var.email
  ingress_class = "nginx"
}

# Deploy the Kubernetes Dashboard ingress
module "dashboard_ingress" {
  source          = "../modules/ingress"
  name            = "kubernetes-dashboard-ingress"
  namespace       = "kubernetes-dashboard"
  annotations     = local.dashboard_annotations
  host            = "dashboard.${var.domain}"
  service_name    = "kubernetes-dashboard"
  service_port    = 443
  tls_secret_name = "dashboard-tls"

  depends_on = [module.cert_manager]
}

# Deploy the ArgoCD ingress
module "argocd_ingress" {
  source          = "../modules/ingress"
  name            = "argocd-server-ingress"
  namespace       = "argocd"
  annotations     = local.argocd_annotations
  host            = "argocd.${var.domain}"
  service_name    = "argo-cd-argocd-server"
  service_port    = 443
  tls_secret_name = "argocd-tls"

  depends_on = [module.cert_manager]
}


data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

output "nginx_ingress_lb_ip" {
  value = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
}

module "dashboard_dns" {
  source             = "../modules/dns"
  cloudflare_email   = var.cloudflare_email
  cloudflare_api_key = var.cloudflare_api_key
  cloudflare_zone_id = var.cloudflare_zone_id
  content            = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
  name               = "dashboard.${var.domain}"
}

module "argocd_dns" {
  source             = "../modules/dns"
  cloudflare_email   = var.cloudflare_email
  cloudflare_api_key = var.cloudflare_api_key
  cloudflare_zone_id = var.cloudflare_zone_id
  content            = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
  name               = "argocd.${var.domain}"

}