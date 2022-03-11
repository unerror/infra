terraform {
  backend "remote" {
    organization = "unerror"

    workspaces {
      name = "unerror"
    }
  }

  required_version = ">= 0.13"

  required_providers {
    helm       = {}
    kubernetes = {}
    random     = {}
    null       = {}
    time       = {}
    sops = {
      source = "carlpett/sops"
    }
    argocd = {
      source  = "oboukili/argocd"
      version = "2.2.6"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.16"
    }
  }

}
