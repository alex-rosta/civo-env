# Recreation of my home environment

It was not good that my cloud addicted ass got my lab equipment taken away

This project assumes that your dns is provided by Cloudflare.
- Kubernetes cluster on Civo Cloud
- Kubernetes Dashboard with ingress
- ArgoCD with ingress
- Cert-manager for TLS certificates with Let's Encrypt, http01 challenge.
- Easily apply argocd manifests to apply gitops deployments.
- Auto creation of DNS records

## Project Structure

I have split the configuration into two stages, infra and k3s.
Run the infra first. and then proceed with k3s.
This is to keep the infrastructure separated from the kubernetes customization.

```
.
├── infra/                      # Infrastructure configuration
│   ├── main.tf                 # Main infrastructure file
│   ├── providers.tf            # Provider configuration
│   └── variables.tf            # Infrastructure variables
├── k3s/                        # Kubernetes resources
│   ├── main.tf                 # Kubernetes resources configuration
│   ├── variables.tf            # Kubernetes variables
│   └── kubeconfig              # Generated kubeconfig file (gitignored)
├── modules/                    # Reusable modules
│   ├── cert_manager/           # Certificate manager module
│   │   └── main.tf             # ClusterIssuer configuration
│   ├── cluster/                # Kubernetes cluster module
│   │   └── main.tf             # Cluster configuration
│   └── ingress/                # Ingress module
│       └── main.tf             # Ingress configuration
├── terraform.tfvars.example    # Example variables configuration
├── .gitignore                  # Git ignore file
└── README.md                   # This file
```

## Getting Started

1. Clone this repository
2. Copy `terraform.tfvars.example` to `terraform.tfvars` and customize the values
3. Initialize infra folder:
   ```
   cd /civoenv/infra && terraform init
   ```
4. Apply the configuration:
   ```
   terraform apply
   ```
<span style="color:red;"><b>(!) Between this stage and the next there may be some delay in getting the ingress ip up. And since the next stage references that ip, there may be errors if it doesn't properly pick it up. Wait a few minutes and then proceed to k3s stage in order for Civo to properly get the nginx ingress up and running.</b></span><br>
5. Proceed to the k3s stage (The kubeconfig file used for cluster operations will be written to the infra folder and referenced)
   ```
   cd ../k3s && terraform init
   terraform apply
   ```

## Accessing Services

After deployment, the following services will be available:

- Kubernetes Dashboard: https://dashboard.yourdomain.com
- ArgoCD Dashboard: https://argocd.yourdomain.com

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