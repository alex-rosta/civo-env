provider "kubernetes" {
  config_path = "${path.module}/kubeconfig"
}

resource "kubernetes_manifest" "ingress-dashboard" {
  manifest = {
    apiVersion = "networking.k8s.io/v1"
    kind       = "Ingress"
    metadata = {
      name      = "kubernetes-dashboard-ingress"
      namespace = "kubernetes-dashboard"
      annotations = {
        "nginx.ingress.kubernetes.io/backend-protocol" = "HTTPS"
        "kubernetes.io/ingress.class"                  = "nginx"
        "cert-manager.io/cluster-issuer"               = "letsencrypt-prod"
      }
    }
    spec = {
      rules = [
        {
          host = "dashboard.rosta.dev"
          http = {
            paths = [
              {
                path     = "/"
                pathType = "Prefix"
                backend = {
                  service = {
                    name = "kubernetes-dashboard"
                    port = {
                      number = 443
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
          hosts      = ["dashboard.rosta.dev"]
          secretName = "dashboard-tls"
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "cert-manager" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = "https://acme-v02.api.letsencrypt.org/directory"
        email  = "alex@rosta.dev"
        privateKeySecretRef = {
          name = "letsencrypt-prod"
        }
        solvers = [
          {
            http01 = {
              ingress = {
                class = "nginx"
              }
            }
          }
        ]
      }
    }
  }
}