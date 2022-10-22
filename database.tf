resource "digitalocean_database_cluster" "db-tor1" {
  name       = "db-tor1"
  engine     = "pg"
  version    = "13"
  size       = "db-s-1vcpu-1gb"
  region     = var.do_region
  node_count = 1
}

resource "digitalocean_database_db" "dbs" {
  for_each = tomap(var.database_dbs)

  name = each.key

  cluster_id = digitalocean_database_cluster.db-tor1.id
}

resource "digitalocean_database_user" "users" {
  for_each = toset(var.database_users)

  name = each.value

  cluster_id = digitalocean_database_cluster.db-tor1.id
}


resource "digitalocean_database_connection_pool" "pools" {
  for_each = tomap(var.database_dbs)

  cluster_id = digitalocean_database_cluster.db-tor1.id
  name       = each.key
  mode       = lookup(each.value, "mode", "transaction")
  size       = each.value.pool_size
  db_name    = digitalocean_database_db.dbs[each.key].name
  user       = length(each.value.user) == 0 ? digitalocean_database_user.users[each.value.user].name : null

  depends_on = [
    digitalocean_database_user.users,
    digitalocean_database_db.dbs
  ]
}

resource "digitalocean_database_firewall" "firewall" {
  cluster_id = digitalocean_database_cluster.db-tor1.id

  dynamic "rule" {
    for_each = var.database_firewall
    content {
      type  = "ip_addr"
      value = rule.value
    }
  }

  rule {
    type  = "k8s"
    value = digitalocean_kubernetes_cluster.une-k8s.id
  }
}
