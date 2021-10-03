resource "digitalocean_spaces_bucket" "docker-registry" {
  name   = var.docker_repo_spaces_name
  region = var.do_spaces_region
  acl    = "private"
}
