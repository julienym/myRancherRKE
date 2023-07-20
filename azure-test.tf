resource "azurerm_resource_group" "this" {
  count = var.azure_enabled ? 1 : 0

  name     = "rg-rke-hybrid"
  location = "canadaeast"
}

resource "azurerm_virtual_network" "this" {
  count = var.azure_enabled ? 1 : 0

  name                = "vnet-rke"
  address_space       = ["10.9.0.0/16"]
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
}

data "http" "icanhazip" {
  count = var.azure_enabled ? 1 : 0

  url = "http://icanhazip.com"
}

resource "azurerm_network_security_group" "this" {
  count = var.azure_enabled ? 1 : 0

  name                = "nsg-rke"
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name

  security_rule {
    name                   = "from_home"
    priority               = 100
    direction              = "Inbound"
    access                 = "Allow"
    protocol               = "Tcp"
    source_port_range      = "*"
    destination_port_range = "*"
    source_address_prefixes = [
      "${chomp(data.http.icanhazip[0].response_body)}/32"
    ]
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet" "this" {
  count = var.azure_enabled ? 1 : 0

  name                 = "subnet-rke"
  resource_group_name  = azurerm_resource_group.this[0].name
  virtual_network_name = azurerm_virtual_network.this[0].name
  address_prefixes     = ["10.9.0.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "this" {
  count = var.azure_enabled ? 1 : 0

  subnet_id                 = azurerm_subnet.this[0].id
  network_security_group_id = azurerm_network_security_group.this[0].id
}

resource "azurerm_public_ip" "this" {
  count = var.azure_enabled ? 1 : 0

  name                = "pip-rke"
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "this" {
  count = var.azure_enabled ? 1 : 0

  name                = "nic-rke-ingress"
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name

  ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.this[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.this[0].id
  }
}

resource "azurerm_linux_virtual_machine" "this" {
  count = var.azure_enabled ? 1 : 0

  name                = "vm-rke-ingress"
  location            = azurerm_resource_group.this[0].location
  resource_group_name = azurerm_resource_group.this[0].name
  network_interface_ids = [
    azurerm_network_interface.this[0].id
  ]
  size = "Standard_B1ms"

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_ssh_key {
    username   = local.ssh.user
    public_key = file(local.ssh.public_key)
  }

  custom_data = base64encode(templatefile("cloud-inits/ubuntu22_azure.yml", {
    root_ca_cert = indent(3, file("${path.root}/${var.root_ca_cert_path}"))
  }))

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "rke-ingress-os"
  }

  computer_name  = "rke-ingress"
  admin_username = local.ssh.user

  provisioner "remote-exec" {
    inline = concat(local.netbird_cmds, [
      "echo \"${var.rancher.wg_ip} ${var.rancher.fqdn}\" | sudo tee -a /etc/hosts",
      "${rancher2_cluster_v2.this.cluster_registration_token[0].node_command} --worker --node-name azure-rke-ingress --label Cloud=Azure --taints Cloud=Azure:NoSchedule ${var.netbird_key != null ? "--internal-address $WG_IP --address $ETH_IP" : ""}"
    ])
  }

  connection {
    type        = "ssh"
    user        = local.ssh.user
    private_key = file(local.ssh.private_key)
    host        = azurerm_public_ip.this[0].ip_address
    port        = local.ssh.port
  }
}

resource "pihole_dns_record" "azure_ingress" {
  count = var.azure_enabled ? var.pihole_password != null ? 1 : 0 : 0

  domain = "ingress.azure.mgt"
  ip     = azurerm_public_ip.this[0].ip_address
}
