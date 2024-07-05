/*resource "argocd_application" "monitoring" {
  metadata {
    name = "monitoring"
  }

  wait = true

  spec {
    project = argocd_project.infra.id

    source {
      repo_url        = var.infra_repo
      path            = "charts/monitoring"
      target_revision = "HEAD"
      helm {
        value_files = ["secrets://secrets.yaml"]
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
      namespace = kubernetes_namespace.une-sys.id
    }
  }

  depends_on = [
    helm_release.argocd,
    argocd_project.infra,
    argocd_repository.infra-git
  ]
}*/

# resource "argocd_application" "monitoring" {
#   metadata {
#     name = "monitoring"
#   }
#
#   wait = true
#
#   spec {
#     project = argocd_project.infra.id
#
#     source {
#       repo_url        = var.infra_repo
#       path            = "charts/datadog"
#       target_revision = "HEAD"
#       helm {
#         value_files = ["values.yaml", "secrets://secrets.yaml"]
#       }
#     }
#
#     sync_policy {
#       automated {
#         allow_empty = false
#         prune       = true
#         self_heal   = true
#       }
#     }
#
#     destination {
#       server    = "https://kubernetes.default.svc"
#       namespace = kubernetes_namespace.une-sys.id
#     }
#   }
#
#   depends_on = [
#     helm_release.argocd,
#     argocd_project.infra,
#     argocd_repository.infra-git
#   ]
# }
