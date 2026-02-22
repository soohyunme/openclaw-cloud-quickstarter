# 1. OCI Authentication
variable "tenancy_ocid" {}
variable "user_ocid" {}
variable "fingerprint" {}
variable "private_key_path" {}
variable "region" {}
variable "compartment_ocid" {}
variable "ssh_public_key" {}

# 2. Project Configuration
variable "namespace" {
  description = "Prefix for all resource names to avoid collisions"
  default     = "openclaw"
}

variable "allowed_ssh_cidr" {
  description = "CIDR block allowed to SSH into the instance (default: 0.0.0.0/0, effectively open to the world)"
  default     = "0.0.0.0/0"
}


# 3. Instance Configuration
variable "instance_shape" {
  default = "VM.Standard.A1.Flex" # Always Free Eligible
}

variable "instance_ocpus" {
  default = 4
}

variable "instance_memory_in_gbs" {
  default = 24
}

variable "boot_volume_size_in_gbs" {
  description = "Boot volume size in GB (Default 50GB, Free Tier gives 200GB total)"
  default     = 50
}

variable "availability_domain_number" {
  description = "The Availability Domain number to use (1, 2, or 3). Try changing this if you get 'Out of Host Capacity' errors."
  type        = number
  default     = 1
  validation {
    condition     = var.availability_domain_number >= 1 && var.availability_domain_number <= 3
    error_message = "Availability Domain number must be 1, 2, or 3."
  }
}

variable "ssh_user" {
  description = "The default user for the VM (e.g., ubuntu for Ubuntu images)"
  default     = "ubuntu"
}

# 4. OpenClaw Configuration
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
