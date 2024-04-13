provider "digitalocean" {
  token = data.sops_file.secrets.data["do_token"]

  spaces_access_id  = data.sops_file.secrets.data["do_spaces_access_id"]
  spaces_secret_key = data.sops_file.secrets.data["do_spaces_secret_key"]

}

provider "helm" {
  registry {
    url = "oci://registry-1.docker.io/casbin"
  }
}

provider "argocd" {
  server_addr = var.argocd_server
  auth_token  = data.sops_file.secrets.data["argocd_token"]
}
