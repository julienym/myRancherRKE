
rke = {
  kubernetes_version = "v1.21.12-rancher1-1"
}

proxmox = {
  cloud_init_file = "ubuntu18_main.yml"
  domain_name = "vm"
  insecure = false
  node_name = "z600"
  debug = false
  use_bastion = true
}

nodes = {
  masters = {
    count = 1
    cores = 2
    ram_mb = 4096
    storage = "SSD"
    clone = "ubuntu18-template"
    bridge = "vmbr0"
    macaddr = [
      "02:77:19:0A:C0:57",
      "02:75:C6:5D:0E:C0",
      "02:4F:DD:54:79:66"
    ]
    roles = [
      "controlplane",
      "etcd"
    ]
    data_disk = [
      {
        mount = "/mnt/etcd"
        storage = "SSD"
        cache = "unsafe"
        size = 200
      }
    ]
  }
}

bastion = {
  host = "bastion.lab-linux.com"
  user = "ubuntu"
  port = 22001
}