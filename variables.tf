variable "database_dbs" {
  type = map(any)
}

variable "database_firewall" {
  type = list(any)
}

variable "database_users" {
  type = list(any)
}

variable "do_region" {
  type    = string
  default = "tor1"
}

variable "kubernetes_vpc_cidr" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.21.3-do.0"
}

variable "kubernetes_tags" {
  type = list(any)
}

variable "kubernetes_node_pools" {
  type = list(any)
}

variable "argocd_server" {
  type = string
}

variable "infra_repo" {
  type = string
}

variable "postgres_version" {
  type    = string
  default = "13"
}
