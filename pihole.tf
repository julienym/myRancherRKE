resource "pihole_dns_record" "masters" {
  count = var.pihole_password != null ? local.masters.count : 0

  domain = "${var.rke.cluster_name}-master-${count.index}.mgt"
  ip     = cidrhost(local.masters.subnet_cidr, count.index + local.masters.ip_start)
}

resource "pihole_dns_record" "workers" {
  count = var.pihole_password != null ? local.workers.count : 0

  domain = "${var.rke.cluster_name}-worker-${count.index}.mgt"
  ip     = cidrhost(local.workers.subnet_cidr, count.index + local.workers.ip_start)
}
