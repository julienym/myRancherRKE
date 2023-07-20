locals {
  proxmox = merge(var.proxmox_default, var.proxmox)
  ssh     = merge(var.ssh_default, var.ssh)
  bastion = merge(var.bastion_default, var.bastion)
  masters = merge(var.nodes_default, var.nodes.masters)
  workers = merge(var.nodes_default, var.nodes.workers)
  cloud_init = {
    master = templatefile("cloud-inits/${var.proxmox.cloud_init_template_file}",
      {
        ssh_pub_key  = file(local.proxmox.ssh_pub_key)
        mount        = var.nodes.masters.data_disk[0].mount
        root_ca_cert = indent(3, file("${path.root}/${var.root_ca_cert_path}"))
    })
    worker = templatefile("cloud-inits/${var.proxmox.cloud_init_template_file}",
      {
        ssh_pub_key  = file(local.proxmox.ssh_pub_key)
        mount        = var.nodes.workers.data_disk[0].mount
        root_ca_cert = indent(3, file("${path.root}/${var.root_ca_cert_path}"))
    })
  }
  chain_ca_cert = "${file("${path.root}/${var.intermediate_ca_cert_path}")}${file("${path.root}/${var.root_ca_cert_path}")}"
  netbird_cmds = var.netbird_key != null ? [
    "curl -fsSL https://pkgs.netbird.io/install.sh | sudo sh",
    "sudo netbird up -k ${var.netbird_key}",
    "sleep 30s",
    "export WG_IP=$(ip -4 -o addr show wt0 | awk '{print $4}' | cut -d'/' -f1)",
    "export ETH_IP=$(ip -4 -o addr show eth0 | awk '{print $4}' | cut -d'/' -f1)",
  ] : []
}