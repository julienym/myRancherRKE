resource "rancher2_cluster" "this" {
  name = local.rke_name
  
  rke_config {
    kubernetes_version = var.rke.kubernetes_version

    network {
      plugin = "canal"
    }
  }
}

resource "rancher2_cluster_sync" "this" {
  depends_on = [
    module.proxmox_node_masters
  ]
  cluster_id = rancher2_cluster.this.id
}
