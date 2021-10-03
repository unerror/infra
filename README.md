# Unerror Network Infrastructure

This repository contains code required to configure and manage the unerror network.

# Encryption

Encryption is provided by [sops](github.com/mozilla/sops) via. terraform integration,
and helm-secrets.

There are currently two age recipients:

- age1a7dumefn2xmd2rqenrldhlqzqedpepnp90e94trzu7eh6xp4hu4qzmv8cq (root key)
- age1zn9hyvar0dv75pvd9e4qkj549ltt3n0t9vwgkptrm0etphrhl3vshp6rd9 (infra key)

Secrets are stored encrypted in SOPS files. The infra key is injected during the terraform
process for ArgoCD to use helm-secrets to inject secrets during CD.

# Terraform

Terraform provided in this cart is the core infrastructure, including bootstrapping the ArgoCD
services.

Encrypted secrets used for Terraform variables are stored in `secrets.enc.yaml`.

# Helm Charts

Helm Charts that are used, either within Terraform, or for deployment to ArgoCD are stored in
the `charts/` directory.

Non-secret values are defined in `values.yaml`. Secrets are stored in sops-encrypted `secrets.yaml`.
