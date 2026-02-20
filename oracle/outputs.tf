output "public_ip" {
  description = "The public IP address of the instance"
  value       = oci_core_instance.openclaw_server.public_ip
}

output "setup_instructions" {
  value = <<EOT
  
  ✅ Oracle Cloud VM Created & Configuration Started!
  
  SSH Command: ssh ubuntu@${oci_core_instance.openclaw_server.public_ip}
  
  ⚠️ IMPORTANT:
  1. Wait 10-20 minutes for installation to complete.
  2. OpenClaw is automatically configured and started with your API Key.
  3. Check status: ssh in and run 'pm2 status'
  EOT
}
