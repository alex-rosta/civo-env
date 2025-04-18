# Civo Kubernetes Cluster with ArgoCD and Dashboard

This project creates a Kubernetes cluster on Civo Cloud with a modular and manageable structure. It includes the following components:

- Kubernetes cluster on Civo Cloud
- Kubernetes Dashboard with ingress
- ArgoCD with ingress
- Cert-manager for TLS certificates with Let's Encrypt

## Project Structure

The project has been modularized for better maintainability:

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
   terraform init
   ```
4. Apply the configuration:
   ```
   terraform apply
   ```

## Accessing Services

After deployment, the following services will be available:

- Kubernetes Dashboard: https://dashboard.yourdomain.com
- ArgoCD Dashboard: https://argocd.yourdomain.com

## Configuration

The project is designed to be easily configurable:

- Modify `terraform.tfvars` to change basic configuration
- Infrastructure settings can be found in `infra/variables.tf`
- Kubernetes resources settings can be found in `k3s/variables.tf`
- Each module has its own variables that can be customized

## Customization

### Adding New Ingresses

To add a new ingress for another service:

1. Use the `ingress` module in the `k3s/main.tf` file:

```hcl
module "new_service_ingress" {
  source          = "../modules/ingress"
  name            = "new-service-ingress"
  namespace       = "new-service-namespace"
  annotations     = local.common_ingress_annotations
  host            = "service.${var.domain}"
  service_name    = "service-name"
  service_port    = 80
  tls_secret_name = "service-tls"
  
  depends_on = [module.cert_manager]
}
```

### Modifying Cluster Configuration

To change the cluster configuration, modify the variables in `terraform.tfvars` or directly in the `infra/variables.tf` file.

## Maintenance

- To update the cluster, modify the configuration and run `terraform apply` again.
- To destroy the infrastructure, run `terraform destroy`.
- All sensitive data is stored in `.tfvars` files which are gitignored.
