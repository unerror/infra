resource "digitalocean_vpc" "kubernetes-tor1" {
  name     = "kubernetes-tor1"
  region   = var.do_region
  ip_range = var.kubernetes_vpc_cidr
}
