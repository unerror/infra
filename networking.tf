resource "digitalocean_vpc" "kubernetes-tor1" {
  name     = "kubernetes-tor1"
  region   = var.do_region
  ip_range = var.kubernetes_vpc_cidr
}

resource "argocd_application" "networking" {
  metadata {
    name = "networking"

    annotations = {
      "argocd.argoproj.io/refresh" = "normal"
    }
  }

  wait = true

  spec {
    project = argocd_project.infra.id
    source {
      repo_url        = var.infra_repo
      path            = "charts/networking"
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
        backoff = {
          duration     = ""
          max_duration = ""
        }
        limit = "0"
      }
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = kubernetes_namespace.une-sys.id
    }
  }

  depends_on = [
    helm_release.argocd,
    argocd_project.infra,
    argocd_repository.infra-git
  ]
}
