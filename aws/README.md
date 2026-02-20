# 🦞 OpenClaw AWS Starter

Create your own **OpenClaw AI Agent** on **Amazon Web Services (AWS)** in minutes.
This Terraform template provisions a **Free Tier (12 Months)** compatible EC2 Instance and automatically installs:
1.  **OpenClaw:** The AI agent platform
2.  **Node.js & PM2:** Process management and runtime environment

---

## 🚀 Quick Start (Using AWS CloudShell)

The easiest way to deploy is using **AWS CloudShell** (a free terminal in your browser). No local installation required!

### 1. Open CloudShell
1.  Log in to the [AWS Management Console](https://aws.amazon.com/console/).
2.  Click the **CloudShell** icon (`>_`) in the top-right header (or search for CloudShell).
3.  Wait for the terminal to initialize.

### 2. Install Terraform
AWS CloudShell needs Terraform installed manually. Run these commands:

```bash
wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip
unzip terraform_1.9.0_linux_amd64.zip
sudo mv terraform /usr/bin/
```

Verify installation:
```bash
terraform -version
```

### 3. Download the Code
Run the following commands in CloudShell:
```bash
git clone https://github.com/soohyunme/openclaw-cloud-quickstarter.git
cd openclaw-cloud-quickstarter/aws
```

### 🏗️ Default Infrastructure
By default, this template provisions:
- **Compute:** `t3.micro` (2 vCPU, 1GB RAM) - Free Tier.
- **Fixed IP:** Elastic IP (EIP) attached to the instance.
- **Network:** Dedicated VPC with a public subnet and Internet Gateway.
- **Security:** Security Group rules for SSH (22) and OpenClaw Gateway (18789).
- **Automation:** User Data script to install Node.js, PM2, and OpenClaw.

### 4. Configuration
Set your variables using `export` (simplest for CloudShell):

1. **Generate SSH Key** (If you don't have one):
   ```bash
   ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
   ```

2. **Set Variables**:
   ```bash
   # 1. Set your AWS Region (Auto-detected in CloudShell)
   export TF_VAR_aws_region=$AWS_REGION

   # 2. Set your LLM API Key (Anthropic or OpenAI)
   # If you don't have one yet, use "none"
   export TF_VAR_llm_api_key="sk-ant-..."
   ```

> **💡 Tip:** Advanced users can create a `terraform.tfvars` file using `nano` or `vim` for persistent configuration. See `terraform.tfvars.example`.

### 5. Deploy! 🏗️
Initialize Terraform and apply the configuration:
```bash
terraform init
terraform apply
```
Review the execution plan. If the proposed changes are correct, type **yes** to approve and proceed with the deployment.

### ⚠️ CRITICAL: Cloud Shell Session Timeout
> [!WARNING]
> AWS CloudShell is an **ephemeral session**. If you are idle for 20-30 minutes, or if your browser closes, **all local files (including your SSH keys and `terraform.tfstate`) will be PERMANENTLY LOST.**
> 
> **You MUST download these files to your local PC immediately after `terraform apply`!**

#### 💾 How to Backup to Your Local PC:
1.  **Download State:** In CloudShell, click **Actions** (top right) -> **Download File**. Path: `openclaw-cloud-quickstarter/aws/terraform.tfstate`
2.  **Download Private Key:** Path: `.ssh/id_rsa`
3.  **Store Safely:** Keep these together in a folder on your computer.

#### 💻 How to Connect from Your Local PC (Safe Way):
If CloudShell expires, you can connect from your own computer (Mac/Linux/WSL):
1.  Move the downloaded `id_rsa` to your `~/.ssh/` folder or a safe directory.
2.  **Set Permissions (Required):** `chmod 400 id_rsa`
3.  **SSH Command:**
    ```bash
    ssh -i id_rsa ubuntu@<YOUR_EIP_IP>
    ```

---

## 🎉 Finalizing Setup

Once deployment is complete (approx. 5-10 minutes), SSH into your server:
```bash
ssh -i ~/.ssh/id_rsa ubuntu@<YOUR_INSTANCE_IP>
```

### 🪄 The Onboarding Wizard
To complete your setup, connect messaging channels (Discord/Telegram), or use other login methods (Gemini/Codex), run the **Onboarding Wizard**:
```bash
openclaw onboard
```
**This wizard will help you:**
*   **Auth:** Link Gemini (Google Antigravity) or GitHub Copilot (Codex).
*   **Channels:** Connect to WhatsApp, Telegram, Discord, etc.
*   **Persona:** Change your agent's name and personality.

### 📊 Check Status
```bash
pm2 status
pm2 logs openclaw
```

---

## 🧹 Clean Up (Destroy)
To remove all resources and stop billing (if any):
```bash
export TF_VAR_llm_api_key="none" # Skip key prompt
terraform destroy
```

## ⚠️ Troubleshooting
*   **Installation is slow:** On low-RAM instances (1GB), OpenClaw is built from source using a swap file. This can take 10-20 minutes. Please be patient.
*   **pm2 command not found:** If the installation just finished, you might need to exit the SSH session and reconnect to refresh your environment variables.

## 📝 Notes on Free Tier
*   **Instance Type:** This template uses `t3.micro` which is Free Tier eligible for 12 months in most regions.
*   **Public IP (EIP):** Includes one Elastic IP. AWS provides 750 hours of public IPv4 for free per month during the first 12 months.
*   **Region:** Some older regions use t2, newer use t3. Check AWS Free Tier limits.

---
**Enjoy your personal AI Agent! 🦞**
