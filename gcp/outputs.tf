output "public_ip" {
  description = "The external IP address of the instance"
  value       = google_compute_instance.openclaw_server.network_interface.0.access_config.0.nat_ip
}

output "setup_instructions" {
  value = <<EOT
  
  ✅ Google Cloud VM Created & Configuration Started!
  
  Cloud/Local SSH: gcloud compute ssh openclaw-server --zone=${var.zone}
  
  ⚠️ CRITICAL:
  1. Download 'terraform.tfstate' NOW to avoid session timeout loss.
  2. RUN './check-progress.sh' to monitor installation (10-20 mins).
  3. Run 'pm2 status' to verify completion.
  EOT
}
