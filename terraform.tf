terraform {
  backend "s3" {
    endpoint = "https://nyc3.digitaloceanspaces.com"

    bucket                      = "infra.unerror.network"
    key                         = "terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    region                      = "us-east-1"
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
      version = "7.0.0"
    }
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.16"
    }
  }

}
