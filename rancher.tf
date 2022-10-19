resource "rancher2_cluster_v2" "this" {
  name = local.rke_name
  
  kubernetes_version = var.rke.kubernetes_version

#   rke_config {
#     chart_values = <<EOF
# etcd-extra-mount: ${var.nodes.masters.data_disk[0].mount}
# EOF
#   }
}

# resource "rancher2_cluster_sync" "this" {
#   depends_on = [
#     module.proxmox_node_masters
#   ]
#   cluster_id = rancher2_cluster_v2.this.id
# }
