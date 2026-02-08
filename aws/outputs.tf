output "public_ip" {
  description = "The public IP address of the instance"
  value       = aws_eip.openclaw_eip.public_ip
}

output "setup_instructions" {
  value = <<EOT
  
  ✅ AWS EC2 Instance Created & Configuration Started!
  
  SSH Command: ssh -i ${var.private_key_path} ubuntu@${aws_eip.openclaw_eip.public_ip}
  
  ⚠️ IMPORTANT:
  1. Wait 5-10 minutes for installation to complete.
  2. OpenClaw is automatically configured and started with your API Key.
  3. Check status: ssh in and run 'pm2 status'
  EOT
}
