variable "proxmox" {}
variable "proxmox_default" {
  type = object({
    insecure          = bool
    debug             = bool
    use_bastion       = bool
    template_location = string
    node_name         = string
    ssh_pub_key       = string
    ssh_private_key   = string
    ssh_port          = number
  })
  description = "Proxmox map"
  default = {
    insecure          = false
    debug             = false
    use_bastion       = false
    template_location = "/var/lib/vz/snippets"
    node_name         = "pmx"
    ssh_pub_key       = "~/.ssh/id_rsa.pub"
    ssh_private_key   = "~/.ssh/id_rsa"
    ssh_port          = 22
  }
}

variable "proxmox_pass" {
  type        = string
  sensitive   = true
  description = "Proxmox auth. password"
}

variable "nodes" {
  description = "Flexible user variable for nodes"
}

variable "nodes_default" {
  type = object({
    target_node = string
    bridge      = string
    clone       = string
    agent       = number
    disk_gb     = number
    ram_mb      = number
    storage     = string
    onboot      = bool
    cores       = number
    macaddr     = list(string)
    roles       = list(string)
  })
  default = {
    target_node = "pmx2"
    bridge      = "vmbr1"
    clone       = "bionic"
    agent       = 0  #False
    disk_gb     = 85 #Must be >= clone
    ram_mb      = 2048
    storage     = "SSD1"
    onboot      = false
    cores       = 2
    macaddr     = [""]
    roles       = ["worker"]
  }
  description = "Map de valeurs par défaut pour les nodes"
}

variable "bastion" {
  default = {}
}

variable "bastion_default" {
  type = object({
    private_key = string
    public_key  = string
    host        = string
    user        = string
    port        = number
  })
  default = {
    private_key = "~/.ssh/id_rsa"
    public_key  = "~/.ssh/id_rsa.pub"
    host        = ""
    user        = ""
    port        = 22
  }
  description = "Default values for using a ssh bastion"
}


variable "ssh" {
  default = {}
}

variable "ssh_default" {
  type = object({
    private_key = string
    public_key  = string
    user        = string
    port        = number
  })
  default = {
    private_key = "~/.ssh/id_rsa"
    public_key  = "~/.ssh/id_rsa.pub"
    user        = "ubuntu"
    port        = 22
  }
  description = "Default values for ssh"
}

variable "rke" {
}


variable "rancher" {
}

# variable "cloudflare" {

# }

variable "azure_enabled" {
  type        = bool
  default     = false
  description = "Enable Azure VM Ingress"
}

variable "root_ca_cert_path" {
  type        = string
  description = "Root CA Certificat path"
}

variable "intermediate_ca_cert_path" {
  type        = string
  description = "Intermediate CA Certificate Certificat path"
}

variable "intermediate_ca_key_path" {
  type        = string
  description = "Intermediate CA Certificate Key path"
}

variable "pihole_password" {
  type        = string
  default     = null
  description = "PiHole admin user password"
  sensitive   = true
}

variable "netbird_key" {
  type        = string
  sensitive   = true
  default     = null
  description = "NetBird auth key"
}

variable "rancher_token" {
  type        = string
  sensitive   = true
  description = "Rancher Token"
}