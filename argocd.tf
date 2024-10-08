resource "kubernetes_secret" "name" {
  metadata {
    name = "age-keyfile"
  }

  data = {
    "keys.txt" = data.sops_file.secrets.data["age_key"]
  }
}

resource "helm_release" "argocd" {
  name = "argocd"

  chart             = "./charts/argocd"
  namespace         = "default"
  dependency_update = true

  values = [
    file("./charts/argocd/values.yaml")
  ]

  dynamic "set_sensitive" {
    for_each = nonsensitive(data.sops_file.argocd-chart-values.data)

    content {
      name  = replace(set_sensitive.key, "dex.config", "dex\\.config")
      value = set_sensitive.value
      type  = "auto"
    }
  }
}

resource "argocd_repository" "infra-git" {
  repo            = var.infra_repo
  username        = "git"
  ssh_private_key = data.sops_file.secrets.data["github_bot_sshkey"]
}

resource "argocd_repository" "oci-ghcr" {
  enable_oci = true
  repo       = "ghcr.io/actions/actions-runner-controller-charts"
  password   = data.sops_file.secrets.data["github_bot_token"]
  type       = "helm"
}

resource "argocd_repository" "oci-dockerhub" {
  enable_oci = true
  repo       = "registry-1.docker.io/casbin"
  type       = "helm"
}

resource "argocd_application" "argocd" {
  metadata {
    name      = "argocd"
    namespace = "default"
  }

  lifecycle {
    ignore_changes = [
      metadata.0.annotations["argocd.argoproj.io/refresh"]
    ]
  }

  wait = true

  spec {
    source {
      repo_url        = var.infra_repo
      path            = "charts/argocd"
      target_revision = "HEAD"
      helm {
        value_files = ["values.yaml", "secrets://secrets.yaml"]
      }
    }

    sync_policy {
      automated {
        allow_empty = false
        prune       = true
        self_heal   = true
      }

      retry {
        backoff {
          duration     = ""
          max_duration = ""
        }
        limit = "0"
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }
  }

  depends_on = [
    helm_release.argocd,
    argocd_repository.infra-git
  ]
}
