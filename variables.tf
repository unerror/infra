variable "database_dbs" {
  type = map
}

variable "database_firewall" {
  type = list
}

variable "database_users" {
  type = list
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
  type = list
}

variable "kubernetes_node_pools" {
  type = list
}

variable "argocd_server" {
  type = string
}

variable "infra_repo" {
  type = string
}
