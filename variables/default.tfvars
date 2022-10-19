
rke = {
  kubernetes_version = "v1.24.4+rke2r1"
}

proxmox = {
  cloud_init_file = "ubuntu18_main.yml"
  domain_name = "vm"
  insecure = false
  node_name = "z600"
  debug = true
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
      "etcd",
    ]
    data_disk = [
      {
        mount = "/var/lib/rancher/rke2/server/db/etcd"
        storage = "SSD"
        cache = "unsafe"
        size = 200
      }
    ]
  }
  workers = {
    count = 1
    cores = 4
    ram_mb = 8192
    storage = "SSD"
    clone = "ubuntu18-template"
    bridge = "vmbr0"
    macaddr = [
      "02:A6:71:E6:02:CE",
      "02:4E:C2:88:ED:B6",
      "02:EF:15:A0:23:DC"
    ]
    roles = [
      "worker"
    ]
    data_disk = [
      {
        mount = "/mnt/longhorn-ssd"
        storage = "SSD"
        cache = "unsafe"
        size = 400
      }
    ]
  }
}

bastion = {
  host = "bastion.lab-linux.com"
  user = "ubuntu"
  port = 22001
}
