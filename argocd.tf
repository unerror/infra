resource "kubernetes_secret" "name" {
  metadata {
    name = "age-keyfile"
  }

  data = {
    "keys.txt" = data.sops_file.secrets.data["age_key"]
  }
}

resource "argocd_repository" "infra-git" {
  repo            = var.infra_repo
  username        = "git"
  ssh_private_key = data.sops_file.secrets.data["github_bot_sshkey"]
}

resource "argocd_application" "argocd" {
  metadata {
    annotations = {
      "argocd.argoproj.io/refresh" = "normal"
    }
    name      = "argocd"
    namespace = "default"
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
      automated = {
        allow_empty = false
        prune       = true
        self_heal   = true
      }

      retry {
        backoff = {}
        limit   = "0"
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }
  }

  depends_on = [
    helm_release.argocd
  ]
}
