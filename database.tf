
resource "digitalocean_database_cluster" "db-tor1" {
  name       = "db-tor1"
  engine     = "pg"
  version    = "13"
  size       = "db-s-1vcpu-1gb"
  region     = var.do_region
  node_count = 1
}

resource "digitalocean_database_db" "dbs" {
  for_each = tomap(var.databases)

  name = each.value.database

  cluster_id = digitalocean_database_cluster.db-tor1.id
}

resource "digitalocean_database_user" "users" {
  for_each = tomap(var.databases)

  name = each.value.user

  cluster_id = digitalocean_database_cluster.db-tor1.id
}


resource "digitalocean_database_connection_pool" "pools" {
  for_each = tomap(var.databases)

  cluster_id = digitalocean_database_cluster.db-tor1.id
  name       = each.value.pool
  mode       = "transaction"
  size       = each.value.pool_size
  db_name    = digitalocean_database_db.dbs[each.value.database].name
  user       = digitalocean_database_user.users[each.value.user].name
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
