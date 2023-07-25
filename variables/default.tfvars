rke = {
  kubernetes_version = "v1.24.13+rke2r1"
  cluster_name       = "tools"
}

proxmox = {
  cloud_init_template_file = "ubuntu22_main.yml"
  domain_name              = "mgt"
  insecure                 = true
  node_name                = "z600"
  debug                    = false
  use_bastion              = false

  url      = "https://z600.home:8006/api2/json",
  user     = "root@pam",
  ssh_host = "z600.home"
  ssh_user = "root"
}

nodes = {
  masters = {
    count       = 1
    cores       = 2
    ram_mb      = 4096
    storage     = "SSD"
    clone       = "ubuntu22-template"
    bridge      = "vmbr1001"
    vlan        = 2
    subnet_cidr = "192.168.102.0/24"
    ip_start    = 8
    gateway     = "192.168.102.1"
    dns         = "192.168.102.253"
    roles = [
      "controlplane",
      "etcd",
    ]
    data_disk = [
      {
        mount   = "/var/lib/rancher/rke2/server/db/etcd"
        storage = "SSD"
        cache   = "unsafe"
        size    = 200
      }
    ]
    onboot   = true
    bootdisk = "virtio0"
    startup  = "order=3,up=30"
  }
  workers = {
    count       = 1
    cores       = 4
    ram_mb      = 8192
    storage     = "SSD"
    clone       = "ubuntu22-template"
    bridge      = "vmbr1001"
    vlan        = 2
    subnet_cidr = "192.168.102.0/24"
    ip_start    = 11
    gateway     = "192.168.102.1"
    dns         = "192.168.102.253"
    roles = [
      "worker"
    ]
    data_disk = [
      {
        mount   = "/mnt/longhorn-ssd"
        storage = "SSD"
        cache   = "unsafe"
        size    = 400
      }
    ]
    onboot   = true
    bootdisk = "virtio0"
    startup  = "order=3,up=30"
  }
}

bastion = {
  # Exemple
  # host = "bastion.lab-linux.com"
  # user = "ubuntu"
  # port = 22001
}

root_ca_cert_path         = "files/encrypted/private_ca.crt"
intermediate_ca_cert_path = "files/encrypted/tools_ca.crt"
intermediate_ca_key_path  = "files/encrypted/tools_ca.key"

rancher = {
  url   = "https://rancher.mgt"
  fqdn  = "rancher.mgt"
  # wg_ip = "100.125.2.2"
}

# azure_enabled = true