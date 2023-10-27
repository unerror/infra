resource "argocd_application" "chatbox" {
  metadata {
    name      = "chatbox"
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
      path            = "charts/chatbox"
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
    argocd_project.infra,
    argocd_repository.infra-git
  ]
}

resource "argocd_application" "vaultwarden" {
  metadata {
    name      = "vaultwarden"
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
      path            = "charts/vaultwarden"
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
}

resource "argocd_application" "community" {
  metadata {
    name      = "community"
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
      path            = "charts/community"
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
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "default"
    }
  }
}
