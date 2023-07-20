provider "proxmox" {
  pm_api_url      = local.proxmox.url
  pm_user         = local.proxmox.user
  pm_password     = var.proxmox_pass
  pm_tls_insecure = local.proxmox.insecure
  pm_log_enable   = local.proxmox.debug
  pm_log_file     = local.proxmox.debug ? "terraform-plugin-proxmox.log" : ""
  pm_log_levels = local.proxmox.debug ? {
    _default    = "info"
    _capturelog = ""
  } : {}
}

provider "helm" {
  kubernetes {
    host  = yamldecode(rancher2_cluster_v2.this.kube_config).clusters[0].cluster.server
    token = yamldecode(rancher2_cluster_v2.this.kube_config).users[0].user.token
  }
}

provider "kubectl" {
  host             = yamldecode(rancher2_cluster_v2.this.kube_config).clusters[0].cluster.server
  token            = yamldecode(rancher2_cluster_v2.this.kube_config).users[0].user.token
  load_config_file = false
}

provider "rancher2" {
  api_url   = var.rancher.url
  token_key = var.rancher_token
}

provider "pihole" {
  url      = "http://pi.mgt"
  password = var.pihole_password
}

provider "azurerm" {
  features {}
}