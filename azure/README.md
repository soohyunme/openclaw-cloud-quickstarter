# 🦞 OpenClaw Azure Starter

Create your own **OpenClaw AI Agent** on **Microsoft Azure** in minutes.
This Terraform template provisions a **Free Tier (12 Months)** compatible VM and automatically installs:
1.  **OpenClaw:** The AI agent platform
2.  **Node.js & PM2:** Process management and runtime environment

---

## 🚀 Quick Start (Using Azure Cloud Shell)

The easiest way to deploy is using **Azure Cloud Shell** (a free terminal in your browser). No local installation required!

### 1. Open Cloud Shell
1.  Log in to the [Azure Portal](https://portal.azure.com/).
2.  Click the **Cloud Shell** icon (`>_`) in the top header.
3.  Select **Bash**.

### 2. Download the Code
Run the following commands in Cloud Shell:
```bash
git clone https://github.com/soohyunme/openclaw-cloud-quickstarter.git
cd openclaw-cloud-quickstarter/azure
```

### 🏗️ Default Infrastructure
By default, this template provisions:
- **Compute:** `Standard_B1s` (1 vCPU, 1GB RAM) - 12 Months Free.
- **Network:** Virtual Network (VNET) with a public IP and subnet.
- **Security:** Network Security Group (NSG) rules for SSH (22) and OpenClaw Gateway (18789).
- **Automation:** Custom Data script to install Node.js, PM2, and OpenClaw.

### 3. Configuration
Set your variables using `export` (simplest for Cloud Shell):

```bash
# 1. SSH Key Path (Default: ~/.ssh/id_rsa.pub)
export TF_VAR_ssh_public_key_path="~/.ssh/id_rsa.pub"

# 2. LLM API Key (Anthropic or OpenAI)
# If you don't have one yet or will use Gemini/Codex login, use "none"
export TF_VAR_llm_api_key="sk-ant-..."
```

> **💡 Tip:** Advanced users can create a `terraform.tfvars` file using `nano` or `vim` for persistent configuration. See `terraform.tfvars.example`.

### 4. Deploy! 🏗️
Initialize Terraform and apply the configuration:
```bash
terraform init
terraform apply
```
Review the execution plan. If the proposed changes are correct, type **yes** to approve and proceed with the deployment.

### ⚠️ Crucial: Backup Your Files
Terraform tracks your resources in `terraform.tfstate`, and your SSH key allows access to the server. **If these files are lost (e.g., Cloud Shell session expires), you will lose access to manage or connect to your resources.**

**To Backup:**
1. After `terraform apply` finishes, click **Actions** (top right) -> **Download File**.
2. Download both files to your local computer:
   *   **State File:** `openclaw-cloud-quickstarter/azure/terraform.tfstate`
   *   **Private Key:** `.ssh/id_rsa` (if generated)

**To Restore:**
If you start a new session, upload both files back to their respective folders before running any commands.

---

## 🎉 Finalizing Setup

Once deployment is complete (approx. 5-10 minutes), SSH into your server:
```bash
ssh azureuser@<YOUR_INSTANCE_IP>
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
*   **Installation is slow:** On low-RAM instances (1GB), OpenClaw is built from source using a swap file. This can take up to 10 minutes. Please be patient.
*   **pm2 command not found:** If the installation just finished, you might need to exit the SSH session and reconnect to refresh your environment variables.

## 📝 Notes on Free Tier
*   **Instance Type:** This template uses `Standard_B1s` (eligible for 750h/month free for 12 months).
*   **Storage:** Includes a standard SSD/HDD managed disk.
*   **Public IP:** Azure may charge for Standard Public IPs. Check Azure pricing.

---
**Enjoy your personal AI Agent! 🦞**
