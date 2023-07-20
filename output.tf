output "azure_ip" {
  value = try(azurerm_public_ip.this[0].ip_address, "No IP found, is azure enabled?")
}
