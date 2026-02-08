output "public_ip" {
  description = "The external IP address of the instance"
  value       = google_compute_instance.openclaw_server.network_interface.0.access_config.0.nat_ip
}

output "setup_instructions" {
  value = <<EOT
  
  ✅ Google Cloud VM Created & Configuration Started!
  
  Access Command: gcloud compute ssh openclaw-server --zone=${var.zone}
  
  ⚠️ IMPORTANT:
  1. Wait 5-10 minutes for installation to complete.
  2. OpenClaw is automatically configured and started with your API Key.
  3. Check status: ssh in and run 'pm2 status'
  EOT
}
