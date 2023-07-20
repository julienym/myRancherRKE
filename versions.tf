terraform {
  required_providers {
    rancher2 = {
      source  = "rancher/rancher2"
      version = "= 3.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "= 1.14.0"
    }
    proxmox = {
      source  = "telmate/proxmox"
      version = "= 2.9.11"
    }
    pihole = {
      source  = "ryanwholey/pihole"
      version = "= 0.0.12"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.64.0"
    }
  }
  required_version = ">= 0.13"
}
