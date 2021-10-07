do_region = "tor1"
databases = {
  homeassistant = {
    pool      = "home-assistant"
    pool_size = 4
    database  = "homeassistant"
    user      = "homeassistant"
  }
}

database_firewall = ["158.69.126.10"]

kubernetes_vpc_cidr = "10.118.0.0/20"
kubernetes_tags     = ["kubernetes", "unerror", "unerror-network"]
kubernetes_version  = "1.21.3-do.0"
kubernetes_node_pools = [{
  name       = "worker-pool"
  size       = "s-2vcpu-4gb"
  node_count = 3
}]

argocd_server = "argo.unerror.network:443"
infra_repo    = "git@github.com:unerror/infra.git"
