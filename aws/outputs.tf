output "public_ip" {
  description = "The public IP address of the instance"
  value       = aws_eip.openclaw_eip.public_ip
}

output "setup_instructions" {
  value = <<EOT
  
  ✅ AWS EC2 Created & Configuration Started!
  
  CloudShell SSH: ssh -i ${var.private_key_path} ubuntu@${aws_eip.openclaw_eip.public_ip}
  Local PC SSH:    ssh -i ./id_rsa ubuntu@${aws_eip.openclaw_eip.public_ip} (Download key first!)
  
  ⚠️ CRITICAL:
  1. Download 'terraform.tfstate' and your private key NOW to avoid session timeout loss.
  2. Wait 10-20 minutes for OpenClaw installation to complete.
  3. Run 'pm2 status' to verify.
  EOT
}
