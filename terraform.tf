terraform {
  backend "remote" {
    organization = "unerror"

    workspaces {
      name = "unerror"
    }
  }

  required_version = ">= 1.2.0"

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
      version = "6.0.1"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.16"
    }
  }

}
