provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.une-k8s.endpoint
  token = digitalocean_kubernetes_cluster.une-k8s.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.une-k8s.kube_config[0].cluster_ca_certificate
  )

}

provider "helm" {
  kubernetes {
    host  = digitalocean_kubernetes_cluster.une-k8s.endpoint
    token = digitalocean_kubernetes_cluster.une-k8s.kube_config[0].token
    cluster_ca_certificate = base64decode(
      digitalocean_kubernetes_cluster.une-k8s.kube_config[0].cluster_ca_certificate
    )
  }
}

data "digitalocean_kubernetes_versions" "latest" {}

data "digitalocean_project" "unerror-network" {
  name = "unerror.network"
}

# Kubernetes Cluster and default nodepool configuration
# (WARNING: changing the defualt node pool size foces a replacement of the whole cluster)
resource "digitalocean_kubernetes_cluster" "une-k8s" {
  name = "une-k8s"

  region = var.do_region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version      = data.digitalocean_kubernetes_versions.latest.latest_version
  tags         = var.kubernetes_tags
  vpc_uuid     = digitalocean_vpc.kubernetes-tor1.id
  auto_upgrade = true

  maintenance_policy {
    day        = "sunday"
    start_time = "06:00"
  }

  dynamic "node_pool" {
    for_each = var.kubernetes_node_pools
    content {
      name       = node_pool.value["name"]
      size       = node_pool.value["size"]
      node_count = node_pool.value["node_count"]
      auto_scale = node_pool.value["auto_scale"]
      max_nodes  = node_pool.value["max_nodes"]
      min_nodes  = node_pool.value["min_nodes"]
    }
  }
}

resource "digitalocean_project_resources" "une-k8s-unerror-network" {
  project = data.digitalocean_project.unerror-network.id
  resources = [
    digitalocean_kubernetes_cluster.une-k8s.urn
  ]
}


# Kubernetes Secret for DO Docker registry
resource "kubernetes_secret" "dockerlogin" {
  metadata {
    name = "do-docker-registry"
  }

  data = {
    ".dockerconfigjson" = data.sops_file.secrets.data["do_registry_login"]
  }

  type = "kubernetes.io/dockerconfigjson"

  depends_on = [
    digitalocean_kubernetes_cluster.une-k8s
  ]
}

resource "kubernetes_namespace" "une-sys" {
  metadata {
    name = "une-sys"
  }
}

# Initial Helm releases (to be replaced to be ArgoCD managed)
resource "helm_release" "base" {
  name = "base"

  chart             = "./charts/base"
  namespace         = kubernetes_namespace.une-sys.id
  timeout           = 900
  dependency_update = true
  skip_crds         = false
  cleanup_on_fail   = true

  values = [
    file("./charts/base/values.yaml")
  ]

  dynamic "set_sensitive" {
    for_each = data.sops_file.base-chart-values.data

    content {
      name  = set_sensitive.key
      value = set_sensitive.value
      type  = "auto"
    }
  }
}

resource "time_sleep" "base-chart-install" {
  depends_on = [
    helm_release.base
  ]

  create_duration = "20s"
}

resource "helm_release" "certs" {
  name = "certs"

  chart     = "./charts/certs"
  namespace = kubernetes_namespace.une-sys.id

  values = [
    file("./charts/certs/values.yaml")
  ]

  depends_on = [
    time_sleep.base-chart-install
  ]
}

# ArgoCD Managed Base Charts
resource "argocd_project" "infra" {
  metadata {
    name      = "infra"
  }

  spec {
    description  = ""
    source_repos = ["*"]

    destination {
      server    = "*"
      namespace = "default"
    }

    destination {
      server    = "*"
      namespace = kubernetes_namespace.une-sys.id
    }

    destination {
      server    = "*"
      namespace = "kube-system"
    }

    cluster_resource_whitelist {
      group = "*"
      kind  = "*"
    }
  }

  lifecycle {
    ignore_changes = [
      spec[0].orphaned_resources
    ]
  }

}

resource "argocd_application" "base" {
  metadata {
    name      = "base"
  }

  wait = true

  spec {
    project = argocd_project.infra.id
    source {
      repo_url        = var.infra_repo
      path            = "charts/base"
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

resource "argocd_application" "certs" {
  metadata {
    name      = "certs"
  }

  wait = true

  spec {
    project = argocd_project.infra.id
    
    source {
      repo_url        = var.infra_repo
      path            = "charts/certs"
      target_revision = "HEAD"
      helm {
        value_files = ["values.yaml"]
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

resource "argocd_application" "csi-s3" {
  metadata {
    name      = "csi-s3"
    namespace = "default"
  }

  wait = true

  spec {
    project = argocd_project.infra.id
    source {
      repo_url        = var.infra_repo
      path            = "charts/csi-s3"
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
      namespace = "kube-system"
    }
  }

  depends_on = [
    helm_release.argocd,
    argocd_project.infra,
    argocd_repository.infra-git
  ]
}
