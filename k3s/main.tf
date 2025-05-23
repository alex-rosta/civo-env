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
  name          = "letsencrypt-prod"
  email         = var.email
  ingress_class = "nginx"
  server        = "https://acme-v02.api.letsencrypt.org/directory"
}

data "kubernetes_service" "nginx_ingress" {
  metadata {
    name      = "ingress-nginx-controller"
    namespace = "ingress-nginx"
  }
}

module "armory_dns" {
  source             = "../modules/dns"
  cloudflare_email   = var.cloudflare_email
  cloudflare_api_key = var.cloudflare_api_key
  cloudflare_zone_id = var.cloudflare_zone_id
  content            = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
  name               = "armory.${var.domain}"
}

resource "kubernetes_manifest" "app-armory" {
  manifest = yamldecode(file("../gitops/argocd/app-armory.yaml"))
}

resource "kubernetes_manifest" "monitoring-grafana" {
  manifest = yamldecode(file("../gitops/argocd/monitoring-grafana.yaml"))
}

resource "kubernetes_secret" "app-armory-secret" {
  metadata {
    name      = "blizz-clientid"
    namespace = "armory"
  }
  data = {
    "CLIENT_ID"              = var.blizz_clientid
    "CLIENT_SECRET"          = var.blizz_clientsecret
    "WARCRAFTLOGS_API_TOKEN" = var.warcraftlogs_api_token
    "REDIS_ADDR"             = var.redis_addr
    "REDIS_PASSWORD"         = var.redis_password
    "REDIS_DB"               = var.redis_db
  }
  depends_on = [kubernetes_manifest.app-armory]

}