provider "digitalocean" {
  token = data.sops_file.secrets.data["do_token"]
}
