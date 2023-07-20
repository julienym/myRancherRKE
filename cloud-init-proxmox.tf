resource "local_file" "cloud_init" {
  for_each = local.cloud_init

  content  = local.cloud_init[each.key]
  filename = "/tmp/cloud_init_${each.key}.yaml"

  provisioner "local-exec" {
    command = "cloud-init schema -c /tmp/cloud_init_${each.key}.yaml --annotate"
    quiet   = true
  }

  provisioner "file" {
    content     = local.cloud_init[each.key]
    destination = "${local.proxmox.template_location}/rke2-${var.rke.cluster_name}-${each.key}"

    connection {
      type                = "ssh"
      user                = local.proxmox.ssh_user
      private_key         = file(local.proxmox.ssh_private_key)
      host                = local.proxmox.ssh_host
      port                = local.proxmox.ssh_port
      bastion_host        = local.proxmox.use_bastion ? local.bastion.host : null
      bastion_user        = local.proxmox.use_bastion ? local.bastion.user : null
      bastion_port        = local.proxmox.use_bastion ? local.bastion.port : null
      bastion_private_key = local.proxmox.use_bastion ? file(local.bastion.ssh_private_key) : null
    }
  }
}
