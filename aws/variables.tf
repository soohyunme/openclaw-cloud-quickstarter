# AWS Configuration
variable "aws_region" {
  description = "The AWS region to deploy to (e.g., us-east-1, ap-northeast-2)"
  default     = "us-east-1"
}

variable "namespace" {
  description = "Prefix for all resource names to avoid collisions"
  default     = "openclaw"
}

variable "instance_type" {
  description = "EC2 Instance Type (t3.small is recommended for better performance; free tier eligible for 6 months on new accounts)"
  default     = "t3.small"
}

variable "disk_size_gb" {
  description = "Root volume size in GB (up to 30GB is free tier eligible)"
  default     = 30
}

variable "disk_type" {
  description = "EBS volume type (gp2/gp3 are standard)"
  default     = "gp2"
}


variable "public_key_path" {
  description = "Path to the local public key file to upload to AWS"
  default     = "~/.ssh/id_rsa.pub"
}

variable "private_key_path" {
  description = "Path to the local private key file (for SSH output instructions only)"
  default     = "~/.ssh/id_rsa"
}

# OpenClaw Configuration
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
