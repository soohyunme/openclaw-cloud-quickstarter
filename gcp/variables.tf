# GCP Configuration (Auto-detected from Cloud Shell)
variable "project_id" {
  description = "GCP Project ID. Automatically set via TF_VAR_project_id or from credentials."
  type        = string
  default     = null # Will use provider default
}

variable "namespace" {
  description = "Prefix for all resource names to avoid collisions"
  default     = "openclaw"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance (default: 0.0.0.0/0, effectively open to the world)"
  default     = "0.0.0.0/0"
}

variable "gateway_cidr" {
  description = "CIDR block allowed to access OpenClaw Gateway (port 18789). Default is open to world (0.0.0.0/0)."
  default     = "0.0.0.0/0"
}

variable "region" {
  description = "The GCP Region (e.g., us-central1 for Free Tier)"
  default     = "us-central1"
}

variable "zone" {
  description = "The GCP Zone (e.g., us-central1-a for Free Tier)"
  default     = "us-central1-a"
}

variable "machine_type" {
  description = "Machine type for the instance (e.g., e2-micro for Free Tier)"
  default     = "e2-micro"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB (30GB is Free Tier eligible)"
  default     = 30
}

variable "disk_type" {
  description = "Boot disk type (pd-standard is Free Tier eligible, pd-balanced/pd-ssd are paid)"
  default     = "pd-standard"
}

# OpenClaw Configuration (Set via TF_VAR_llm_api_key)
variable "openclaw_model" {
  description = "The AI model to use (e.g., claude-3-5-sonnet-20241022)"
  type        = string
  default     = "claude-3-5-sonnet-20241022"
}

variable "llm_api_key" {
  description = "Your LLM API Key (e.g., Anthropic 'sk-ant-...' or OpenAI 'sk-...')"
  type        = string
  sensitive   = true
  default     = "none"
}
