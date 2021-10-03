variable "databases" {
  type = map
}

variable "database_firewall" {
  type = list
}

variable "do_region" {
  type    = string
  default = "tor1"
}

variable "do_spaces_region" {
  type    = string
  default = "nyc3"
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

variable "https_infra_repo" {
  type = string
}

variable "docker_repo_spaces_name" {
  type = string
}
