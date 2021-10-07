resource "argocd_application" "monitoring" {
  metadata {
    name      = "monitoring"
    namespace = "default"
  }

  wait = true

  spec {
    source {
      repo_url        = var.infra_repo
      path            = "charts/monitoring"
      target_revision = "HEAD"
      helm {
        value_files = ["secrets://secrets.yaml"]
      }
    }

    sync_policy {
      automated = {
        allow_empty = false
        prune       = true
        self_heal   = true
      }

      retry {
        backoff = {
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
    helm_release.argocd
  ]
}
