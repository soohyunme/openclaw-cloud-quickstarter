output "public_ip" {
  description = "The public IP address of the instance"
  value       = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "setup_instructions" {
  value = <<EOT
  
  ✅ Azure VM Created & Configuration Started!
  
  CloudShell SSH: ssh ${var.admin_username}@${azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address}
  Local PC SSH:    ssh ${var.admin_username}@${azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address} (Ensure key is local)
  
  ⚠️ CRITICAL:
  1. Download 'terraform.tfstate' and your private key NOW to avoid session timeout loss.
  2. Wait 10-20 minutes for installation to complete.
  3. Run 'pm2 status' to verify.
  EOT
}
