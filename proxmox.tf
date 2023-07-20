module "proxmox_node_masters" {
  depends_on = [
    local_file.cloud_init
  ]
  source = "git::https://github.com/julienym/myTerraformModules.git//proxmox?ref=main"
  count  = local.masters.count

  name        = "${var.rke.cluster_name}-master-${count.index}"
  domain_name = var.proxmox.domain_name

  target_node      = local.proxmox.node_name
  agent            = "0"
  onboot           = local.masters.onboot
  startup          = local.masters.startup
  snippet_filename = "rke2-${var.rke.cluster_name}-master"
  bridge           = local.masters.bridge
  vlan             = local.masters.vlan
  clone            = local.masters.clone
  disk_gb          = local.masters.disk_gb
  ram_mb           = local.masters.ram_mb
  cores            = local.masters.cores
  storage          = local.masters.storage
  ipconfig         = "${cidrhost(local.masters.subnet_cidr, count.index + local.masters.ip_start)}/${split("/", local.masters.subnet_cidr)[1]}"
  gateway          = local.masters.gateway
  dns              = local.masters.dns
  ssh              = local.ssh
  bastion          = local.bastion
  bootdisk         = local.masters.bootdisk
  data_disk        = local.masters.data_disk
  provision_verification = [
    "cloud-init status --wait > /dev/null",
    "sudo hostnamectl set-hostname ${var.rke.cluster_name}-master-${count.index}",
  ]
}

resource "null_resource" "rancher_masters_join" {
  depends_on = [
    module.proxmox_node_masters
  ]
  count = local.masters.count

  provisioner "remote-exec" {
    inline = concat(local.netbird_cmds, [
      "${rancher2_cluster_v2.this.cluster_registration_token[0].node_command} --controlplane --etcd --node-name ${var.rke.cluster_name}-master-${count.index} ${var.netbird_key != null ? "--internal-address $WG_IP --address $ETH_IP" : ""}"
    ])
  }

  connection {
    type                = "ssh"
    user                = local.ssh.user
    private_key         = file(local.ssh.private_key)
    host                = "${var.rke.cluster_name}-master-${count.index}.${var.proxmox.domain_name}"
    port                = local.ssh.port
    bastion_host        = local.bastion.host != "" ? local.bastion.host : null
    bastion_user        = local.bastion.host != "" ? local.bastion.user : null
    bastion_port        = local.bastion.host != "" ? local.bastion.port : null
    bastion_private_key = local.bastion.host != "" ? file(local.bastion.private_key) : ""
  }
}


module "proxmox_node_workers" {
  depends_on = [
    local_file.cloud_init
  ]
  source = "git::https://github.com/julienym/myTerraformModules.git//proxmox?ref=main"
  count  = local.workers.count

  name        = "${var.rke.cluster_name}-worker-${count.index}"
  domain_name = var.proxmox.domain_name

  target_node      = local.proxmox.node_name
  agent            = "0"
  onboot           = local.workers.onboot
  startup          = local.workers.startup
  snippet_filename = "rke2-${var.rke.cluster_name}-worker"
  bridge           = local.workers.bridge
  vlan             = local.masters.vlan
  clone            = local.workers.clone
  disk_gb          = local.workers.disk_gb
  ram_mb           = local.workers.ram_mb
  cores            = local.workers.cores
  storage          = local.workers.storage
  ipconfig         = "${cidrhost(local.workers.subnet_cidr, count.index + local.workers.ip_start)}/${split("/", local.workers.subnet_cidr)[1]}"
  gateway          = local.workers.gateway
  dns              = local.workers.dns
  ssh              = local.ssh
  bastion          = local.bastion
  bootdisk         = local.workers.bootdisk
  data_disk        = local.workers.data_disk
  provision_verification = [
    "cloud-init status --wait > /dev/null",
    "sudo hostnamectl set-hostname ${var.rke.cluster_name}-worker-${count.index}",
  ]
}

resource "null_resource" "rancher_workers_join" {
  depends_on = [
    module.proxmox_node_workers
  ]
  count = local.workers.count

  provisioner "remote-exec" {
    inline = concat(local.netbird_cmds, [
      "${rancher2_cluster_v2.this.cluster_registration_token[0].node_command} --worker --node-name ${var.rke.cluster_name}-worker-${count.index} ${var.netbird_key != null ? "--internal-address $WG_IP --address $ETH_IP" : ""}"
    ])
  }

  connection {
    type                = "ssh"
    user                = local.ssh.user
    private_key         = file(local.ssh.private_key)
    host                = "${var.rke.cluster_name}-worker-${count.index}.${var.proxmox.domain_name}"
    port                = local.ssh.port
    bastion_host        = local.bastion.host != "" ? local.bastion.host : null
    bastion_user        = local.bastion.host != "" ? local.bastion.user : null
    bastion_port        = local.bastion.host != "" ? local.bastion.port : null
    bastion_private_key = local.bastion.host != "" ? file(local.bastion.private_key) : ""
  }
}
