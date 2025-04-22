# Recreation of my home environment

It was not good that my cloud addicted ass got my lab equipment taken away

- Kubernetes cluster on Civo Cloud
- Kubernetes Dashboard with ingress
- ArgoCD with ingress
- Cert-manager for TLS certificates with Let's Encrypt
- Easily apply argocd manifests to apply gitops deployments.

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
3. Initialize Terraform:
   ```
   cd /civoenv/infra && terraform init
   ```
4. Apply the configuration:
   ```
   terraform apply
   ```
5. Proceed to the k3s stage
   ```
   cd ../k3s && terraform init
   ```

## Accessing Services

After deployment, the following services will be available:

- Kubernetes Dashboard: https://dashboard.yourdomain.com
- ArgoCD Dashboard: https://argocd.yourdomain.com

Get the argocd initial secret: 
```
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | ForEach-Object { [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($_)) }
```

## Configuration

The project is designed to be easily configurable:

- Modify `terraform.tfvars` to change basic configuration
- Infrastructure settings can be found in `infra/variables.tf`
- Kubernetes resources settings can be found in `k3s/variables.tf`
- Each module has its own variables that can be customized

