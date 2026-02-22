output "public_ip" {
  description = "The public IP address of the instance"
  value       = oci_core_instance.openclaw_server.public_ip
}

output "setup_instructions" {
  value = <<EOT

✅ Oracle Cloud VM Created & Configuration Started!

1. CONNECT & MONITOR (Wait ~15 mins):
   CloudShell SSH: ssh -i <path_to_your_key> -L 18789:localhost:18789 ${var.ssh_user}@${oci_core_instance.openclaw_server.public_ip}
   Local PC SSH:    ssh -i ./id_rsa -L 18789:localhost:18789 ${var.ssh_user}@${oci_core_instance.openclaw_server.public_ip}

   Inside the terminal, run:
   ./check-progress.sh

2. ACCESS DASHBOARD:
   Once 100% complete, the **Full Link (with token)** will appear in your SSH window.
   Copy and paste it into your browser (e.g., http://localhost:18789/#token=...).

3. FINISH SETUP:
   In the same terminal, run:
   openclaw onboard

⚠️ CRITICAL:
- Download 'terraform.tfstate' from CloudShell NOW to avoid resource management issues.
- If you lose your token, simply log in again; the Login Banner (MOTD) will show it live.
EOT
}
