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

data "akeyless_static_secret" "armory_secrets" {
  path = "/armory/blizzard"
}

data "akeyless_static_secret" "cloudflare_secrets" {
  path = "/cloudflare/cloudflare"

}

data "akeyless_static_secret" "postfix_secrets" {
  path = "/postfix/postfix"

}

locals {
  armory_secrets = jsondecode(data.akeyless_static_secret.armory_secrets.value)
}

locals {
  cloudflare_secrets = jsondecode(data.akeyless_static_secret.cloudflare_secrets.value)
}

locals {
  postfix_secrets = jsondecode(data.akeyless_static_secret.postfix_secrets.value)
}

module "armory_dns" {
  source             = "../modules/dns"
  cloudflare_email   = local.cloudflare_secrets.cloudflare_email
  cloudflare_api_key = local.cloudflare_secrets.cloudflare_api_key
  cloudflare_zone_id = local.cloudflare_secrets.cloudflare_zone_id
  content            = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
  name               = "armory.${local.cloudflare_secrets.domain}"
}

resource "kubernetes_manifest" "app-armory" {
  manifest = yamldecode(file("../gitops/argocd/app-armory.yaml"))
}

resource "kubernetes_manifest" "monitoring-grafana" {
  manifest = yamldecode(file("../gitops/argocd/monitoring-grafana.yaml"))
}

resource "kubernetes_manifest" "app-postfix" {
  manifest = yamldecode(file("../gitops/argocd/app-postfix.yaml"))
}

resource "kubernetes_secret" "app-armory-secret" {
  metadata {
    name      = "blizz-clientid"
    namespace = "armory"
  }
  data = {
    "CLIENT_ID"              = local.armory_secrets.client_id
    "CLIENT_SECRET"          = local.armory_secrets.client_secret
    "WARCRAFTLOGS_API_TOKEN" = local.armory_secrets.warcraftlogs_token
    "REDIS_ADDR"             = local.armory_secrets.redis_addr
    "REDIS_PASSWORD"         = local.armory_secrets.redis_password
    "REDIS_DB"               = local.armory_secrets.redis_db
  }
  depends_on = [kubernetes_manifest.app-armory]

}

resource "kubernetes_secret" "app-postfix-secret" {
  metadata {
    name      = "postfix-relayhost"
    namespace = "postfix"
  }
  data = {
    "username" = local.postfix_secrets.postfix_username
    "password" = local.postfix_secrets.postfix_password
  }
  depends_on = [kubernetes_manifest.app-postfix]

}