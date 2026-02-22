output "public_ip" {
  description = "The public IP address of the instance"
  value       = aws_eip.openclaw_eip.public_ip
}

output "setup_instructions" {
  value = <<EOT
  
  ✅ AWS EC2 Created & Configuration Started!
  
  CloudShell SSH: ssh -i ${var.private_key_path} -L 18789:localhost:18789 ubuntu@${aws_eip.openclaw_eip.public_ip}
  Local PC SSH:    ssh -i ./id_rsa -L 18789:localhost:18789 ubuntu@${aws_eip.openclaw_eip.public_ip}
  
  ⚠️ CRITICAL:
  1. Download 'terraform.tfstate' and your private key NOW.
  2. RUN './check-progress.sh' to monitor installation (15-20 mins).
  3. AFTER COMPLETE, run 'openclaw onboard' to set up your AI models!
  EOT
}
