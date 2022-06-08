resource "null_resource" "cloud_init_config_file_master" {
  provisioner "file" {
    content = local.master_snippet
    destination = "${local.proxmox.template_location}/rke-${var.proxmox.cloud_init_file}-master"

    connection {
      type     = "ssh"
      user     = local.proxmox_secrets.ssh_user
      private_key = file(local.proxmox.ssh_private_key)
      host     = local.proxmox_secrets.ssh_host
      port     = local.proxmox_secrets.ssh_port
      bastion_host = local.proxmox.use_bastion ? local.bastion.host : null
      bastion_user = local.proxmox.use_bastion ? local.bastion.user : null
      bastion_port = local.proxmox.use_bastion ? local.bastion.port : null
      bastion_private_key = local.proxmox.use_bastion ? file(local.bastion.ssh_private_key) : null
    }
  }

  triggers = {
    fileSHA = sha256(local.master_snippet)
  }
}

module "proxmox_node_masters" {
  depends_on = [
    null_resource.cloud_init_config_file_master
  ]
  # source = "git::https://github.com/julienym/myTerraformModules.git//proxmox?ref=dev"
  source = "../myTerraformModules/proxmox"
  count = local.masters.count

  providers = {
    proxmox = proxmox
  }
  name = "${local.rke_name}-master-${count.index}"
  domain_name = var.proxmox.domain_name
  
  target_node = local.proxmox.node_name
  agent = "0"
  snippet_filename = "rke-${var.proxmox.cloud_init_file}-master"
  snippet_sha256 = sha256(local.master_snippet)
  bridge = local.masters.bridge
  clone = local.masters.clone
  disk_gb = local.masters.disk_gb
  ram_mb = local.masters.ram_mb
  cores = local.masters.cores
  storage = local.masters.storage
  onboot = local.masters.onboot
  macaddr = local.masters.macaddr[count.index]
  bastion = local.bastion
  data_disk = local.masters.data_disk
}


# module "proxmox_node_workers" {
#   depends_on = [
#     null_resource.cloud_init_config_file_worker
#   ]
#   source = "../../modules/proxmox"
#   count = local.workers.count

#   providers = {
#     proxmox = proxmox
#   }
#   name = "${local.workers.name_prefix}-${count.index}"
#   domain_name = var.domain_name
  
#   target_node = local.proxmox.node_name
#   agent = "0"
#   snippet = "${path.module}/templates/worker.yml"
#   bridge = local.workers.bridge
#   clone = local.workers.clone
#   disk_gb = local.workers.disk_gb
#   ram_mb = local.workers.ram_mb
#   cores = local.workers.cores
#   storage = local.workers.storage
#   onboot = local.workers.onboot
#   macaddr = local.workers.macaddr[count.index]
#   bastion = local.bastion
#   data_disk = local.workers.data_disk
# }
