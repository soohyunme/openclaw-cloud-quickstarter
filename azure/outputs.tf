output "public_ip" {
  description = "The public IP address of the instance"
  value       = azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address
}

output "setup_instructions" {
  value = <<EOT
  
  ✅ Azure VM Created & Configuration Started!
  
  SSH Command: ssh ${var.admin_username}@${azurerm_linux_virtual_machine.my_terraform_vm.public_ip_address}
  
  ⚠️ IMPORTANT:
  1. Wait 10-20 minutes for installation to complete.
  2. OpenClaw is automatically configured and started with your API Key.
  3. Check status: ssh in and run 'pm2 status'
  EOT
}
