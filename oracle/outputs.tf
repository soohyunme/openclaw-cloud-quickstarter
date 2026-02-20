output "public_ip" {
  description = "The public IP address of the instance"
  value       = oci_core_instance.openclaw_server.public_ip
}

output "setup_instructions" {
  value = <<EOT
  
  ✅ Oracle Cloud VM Created & Configuration Started!
  
  CloudShell SSH: ssh ubuntu@${oci_core_instance.openclaw_server.public_ip}
  Local PC SSH:    ssh ubuntu@${oci_core_instance.openclaw_server.public_ip}
  
  ⚠️ CRITICAL:
  1. Download 'terraform.tfstate' NOW to avoid session timeout loss.
  2. Wait 10-20 minutes for installation to complete.
  3. Run 'pm2 status' to verify.
  EOT
}
