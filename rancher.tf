resource "rancher2_cluster_v2" "this" {
  name = var.rke.cluster_name

  kubernetes_version = var.rke.kubernetes_version

  rke_config {
    chart_values = templatefile("files/rke_config.yaml", {
      FLANNEL_IFACE = var.netbird_key != null ? "wt0" : ""
      AZURE_INGRESS = var.azure_enabled
    })

    machine_global_config = <<-EOF
      cni: "canal"
    EOF

    # WIP
    # registries {
    #   mirrors {
    #     hostname = "harbor.tools.home"
    #     endpoints = ["https://harbor.tools.home"]
    #   }
    #   configs {
    #     hostname = "harbor.tools.home"
    #     auth_config_secret_name = rancher2_secret_v2.harbor_registry_auth.name
    #     # ca_bundle = file("${path.root}/${var.ca_cert_path}")
    #   }
    # }
  }
}

resource "rancher2_cluster_sync" "this" {
  depends_on = [
    module.proxmox_node_masters,
    module.proxmox_node_workers,
    null_resource.rancher_masters_join,
    null_resource.rancher_workers_join,
  ]
  cluster_id = rancher2_cluster_v2.this.cluster_v1_id
}
