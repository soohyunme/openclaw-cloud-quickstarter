# 1. Azure Resource Configuration
variable "resource_group_location" {
  description = "Location for all resources."
  default     = "eastus"
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
  description = "CIDR block allowed to access OpenClaw Gateway (port 18789). Default is open to world (*)."
  default     = "*"
}

# 2. Virtual Machine Configuration
variable "vm_size" {
  description = "The size of the Virtual Machine."
  default     = "Standard_B1s" # Free Tier (12 months)
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB (Standard is 30GB-64GB)."
  default     = 64
}

variable "os_disk_type" {
  description = "Type of managed disk (Standard_LRS, StandardSSD_LRS, Premium_LRS)."
  default     = "Standard_LRS"
}

variable "admin_username" {
  description = "The username for the local account that will be created on the new VM."
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key file (e.g., ~/.ssh/id_rsa.pub)."
  default     = "~/.ssh/id_rsa.pub"
}

# 3. OpenClaw Configuration
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
