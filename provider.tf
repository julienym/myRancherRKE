provider "proxmox" {
    pm_api_url = local.proxmox_secrets.url
    pm_user = local.proxmox_secrets.user
    pm_password = local.proxmox_secrets.pass
    pm_tls_insecure = local.proxmox.insecure
    pm_log_enable = local.proxmox.debug
    pm_log_file = local.proxmox.debug ? "terraform-plugin-proxmox.log" : ""
    pm_log_levels = local.proxmox.debug ? {
        _default = "info"
        _capturelog = ""
    } : {}
}

# provider "helm" {
#   kubernetes {
#     host             =    yamldecode(rancher2_cluster_v2.this.kube_config).clusters[0].cluster.server
#     token            =    yamldecode(rancher2_cluster_v2.this.kube_config).users[0].user.token 
#     # cluster_ca_certificate = yamldecode(rancher2_cluster_v2.this.kube_config).clusters[0].cluster.certificate-authority-data
#   }
# }

# provider "kubectl" {
#   host     = "https://${var.api_domain}:6443"

#   client_certificate     = module.rke.client_cert 
#   client_key             = module.rke.client_key 
#   cluster_ca_certificate = module.rke.ca_crt 
#   load_config_file       = false
# }

provider "rancher2" {

  api_url = var.rancher.url
  token_key = var.rancher.token
}
