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

resource "digitalocean_kubernetes_cluster" "une-k8s" {
  name = "une-k8s"

  region = var.do_region
  # Grab the latest version slug from `doctl kubernetes options versions`
  version      = var.kubernetes_version
  tags         = var.kubernetes_tags
  vpc_uuid     = digitalocean_vpc.kubernetes-tor1.id
  auto_upgrade = true

  maintenance_policy {
    day        = "sunday"
    start_time = "13:00"
  }

  dynamic "node_pool" {
    for_each = var.kubernetes_node_pools
    content {
      name       = node_pool.value["name"]
      size       = node_pool.value["size"]
      node_count = node_pool.value["node_count"]
    }
  }
}

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

resource "helm_release" "base" {
  name = "base"

  chart             = "./charts/base"
  namespace         = "default"
  timeout           = 900
  dependency_update = true
  skip_crds         = false
  cleanup_on_fail   = true

  values = [
    file("./charts/base/values.yaml")
  ]

  set_sensitive {
    name  = "docker-registry.secrets.s3.accessKey"
    value = data.sops_file.secrets.data["do_spaces_access_id"]
  }

  set_sensitive {
    name  = "docker-registry.secrets.s3.secretKey"
    value = data.sops_file.secrets.data["do_spaces_secret_key"]
  }

  set {
    name  = "docker-registry.s3.region"
    value = digitalocean_spaces_bucket.docker-registry.region
  }

  set {
    name  = "docker-registry.s3.regionEndpoint"
    value = replace(digitalocean_spaces_bucket.docker-registry.bucket_domain_name, "${digitalocean_spaces_bucket.docker-registry.name}.", "")
  }

  set {
    name  = "docker-registry.s3.bucket"
    value = digitalocean_spaces_bucket.docker-registry.bucket_domain_name
  }

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

resource "helm_release" "argocd" {
  name = "argocd"

  chart             = "./charts/argocd"
  namespace         = "default"
  dependency_update = true

  values = [
    file("./charts/argocd/values.yaml")
  ]

  dynamic "set_sensitive" {
    for_each = data.sops_file.argocd-chart-values.data

    content {
      name  = replace(set_sensitive.key, "dex.config", "dex\\.config")
      value = set_sensitive.value
      type  = "auto"
    }
  }

  depends_on = [
    time_sleep.base-chart-install
  ]
}


resource "helm_release" "certs" {
  name = "certs"

  chart     = "./charts/certs"
  namespace = "default"

  values = [
    file("./charts/certs/values.yaml")
  ]

  depends_on = [
    time_sleep.base-chart-install
  ]
}
