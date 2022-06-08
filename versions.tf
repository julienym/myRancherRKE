terraform {
  required_providers {
    rancher2 = {
      source = "rancher/rancher2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
    }
    proxmox = {
      source = "Telmate/proxmox"
    }
  }
  required_version = ">= 0.13"
}
