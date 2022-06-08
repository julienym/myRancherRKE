locals {
  proxmox = merge(var.proxmox_default, var.proxmox)
  proxmox_secrets = merge(var.proxmox_secrets_default, var.proxmox_secrets)
  bastion = merge(var.bastion_default, var.bastion)
  masters = merge(var.nodes_default, var.nodes.masters)
  # workers = merge(var.nodes_default, var.nodes.workers)
  rke_name = "rke${terraform.workspace == "default" ? "" : "-${terraform.workspace}"}"
  master_snippet = templatefile("cloud-inits/${var.proxmox.cloud_init_file}",
    {
      ssh_pub_key = file(local.proxmox.ssh_pub_key)
      mount = var.nodes.masters.data_disk[0].mount
      rancher_join_command = rancher2_cluster.this.cluster_registration_token[0].node_command
      roles = var.nodes.masters.roles
    }
  )
}