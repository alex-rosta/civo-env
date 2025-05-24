# Recreation of my home environment

It was not good that my cloud addicted ass got my lab equipment taken away

This project assumes that your dns is provided by Cloudflare.
- Kubernetes cluster on Civo Cloud
- Grafana & Prometheus with dashboard preconfigured
- ArgoCD for Gitops deployments
- Cert-manager for TLS certificates with Let's Encrypt, http01 challenge
- Deploys a sample application of mine
- Auto creation of DNS records
- Nginx ingress

## Project Structure

I have split the configuration into two "stages", infra and k3s.
Run the infra first. and then proceed with k3s.
This is to keep the infrastructure separated from the application layer.

## Getting Started

1. Clone this repository
2. Copy `terraform.tfvars.example` to `terraform.tfvars` and customize the values
3. Initialize infra folder:
   ```
   cd /civoenv/infra && terraform init
   ```
4. Apply the configuration:
   ```
   terraform plan
   terraform apply
   ```
<span style="color:red;"><b>(!) Between this stage and the next there may be some delay in getting the ingress ip up. And since the next stage references that ip, there may be errors if it doesn't properly pick it up. Wait a few minutes and then proceed to k3s stage in order for Civo to properly get the nginx ingress up and running.</b></span><br>
5. Proceed to the k3s stage (The kubeconfig file used for cluster operations will be written to the infra folder and referenced)
   ```
   cd ../k3s && terraform init
   terraform plan
   terraform apply
   ```

## Accessing Services

After deployment, the following services will be available:

- Armory application (Sample app): https://armory.yourdomain.com

Get the argocd initial secret: 
```
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

## Deploying more services

Adding your own services to the cluster is easy through ArgoCD yaml deployments. Just add them in gitops\argocd like the example, and reference them with a manifest block like such;
```hcl
resource "kubernetes_manifest" "app-armory" {
  manifest = yamldecode(file("../gitops/argocd/app-armory.yaml"))
}
```
And DNS if you want;
```hcl
module "customapp_dns" {
  source             = "../modules/dns"
  cloudflare_email   = var.cloudflare_email
  cloudflare_api_key = var.cloudflare_api_key
  cloudflare_zone_id = var.cloudflare_zone_id
  content            = data.kubernetes_service.nginx_ingress.status[0].load_balancer[0].ingress[0].ip
  name               = "custom_app.${var.domain}"
}