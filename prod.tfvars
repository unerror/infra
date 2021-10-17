do_region = "tor1"

database_users = ["homeassistant", "matrix"]
database_dbs = {
  homeassistant = {
    pool_size = 2
    user      = "homeassistant"
  }

  synapse = {
    pool_size = 2
    user      = "matrix"
  }

  matrix_appservice_irc = {
    pool_size = 2
    user      = "matrix"
  }

  matrix_dimension = {
    pool_size = 2
    user      = "matrix"
  }

  matrix_ma1sd = {
    pool_size = 2
    user      = "matrix"
  }

  matrix_mautrix_hangouts = {
    pool_size = 2
    mode      = "session"
    user      = "matrix"
  }

  matrix_reminder_bot = {
    pool_size = 2
    user      = "matrix"
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
  auto_scale = true
  max_nodes  = 5
  min_nodes  = 3
}]

argocd_server = "argo.unerror.network:443"
infra_repo    = "git@github.com:unerror/infra.git"
