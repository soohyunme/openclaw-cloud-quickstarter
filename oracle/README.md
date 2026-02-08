# 🦞 OpenClaw Oracle Starter (Always Free)

Create your own **OpenClaw AI Agent** on **Oracle Cloud Infrastructure (OCI)** in minutes.
This Terraform template provisions a **Free Tier (Always Free)** compatible VM (ARM Ampere A1) and automatically installs:
1.  **OpenClaw:** The AI agent platform
2.  **Node.js & PM2:** Process management and runtime environment

---

## 🚀 Quick Start (Using Cloud Shell)

The easiest way to deploy is using **OCI Cloud Shell** (a free terminal in your browser). No local installation required!

### 1. Open Cloud Shell
1.  Log in to the [Oracle Cloud Console](https://cloud.oracle.com/).
2.  Click the **Developer Tools** icon (terminal icon `>_`) in the top-right header.
3.  Select **Cloud Shell**.

### 2. Download the Code
Run the following commands in Cloud Shell:
```bash
git clone https://github.com/soohyunme/openclaw-cloud-quickstarter.git
cd openclaw-cloud-quickstarter/oracle
```

### 🏗️ Default Infrastructure
By default, this template provisions:
- **Compute:** `VM.Standard.A1.Flex` (4 OCPU, 24GB RAM) - Always Free.
- **Network:** Virtual Cloud Network (VCN) with a Public Subnet.
- **Security:** Ingress rules for SSH (22) and OpenClaw Gateway (18789).
- **Automation:** Automated installation of Node.js, PM2, and OpenClaw.

### 3. Configuration
Set your variables using `export` (simplest for Cloud Shell):

```bash
# 1. OCI Authentication (Get these from OCI Console)
export TF_VAR_tenancy_ocid="ocid1.tenancy..."
export TF_VAR_user_ocid="ocid1.user..."
export TF_VAR_fingerprint="xx:xx:xx..."
export TF_VAR_private_key_path="~/.oci/oci_api_key.pem"
export TF_VAR_region="ap-seoul-1"
export TF_VAR_compartment_ocid="ocid1.compartment..."
export TF_VAR_ssh_public_key="ssh-rsa AAAA..."

# 2. LLM API Key
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
Terraform tracks your resources in a file called `terraform.tfstate`. **If this file is lost (e.g., Cloud Shell session expires), you cannot easily manage or destroy your resources.**

**To Backup:**
1. After `terraform apply` finishes, click **Actions** (top right) -> **Download File**.
2. Enter the path: `openclaw-cloud-quickstarter/oracle/terraform.tfstate`
3. Save it to your local computer.

**To Restore:**
If you start a new session, upload the file back to the same folder before running any commands.

---

## 🎉 Finalizing Setup

Once deployment is complete, SSH into your server:
```bash
ssh ubuntu@<YOUR_INSTANCE_IP>
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
*   **"Out of Host Capacity" Error:** Oracle Free Tier ARM instances are popular and sometimes out of stock.
    *   Try a different Availability Domain by setting `export TF_VAR_availability_domain_number=2` (if available in your region).
    *   Try a different region or retry later.
*   **pm2 command not found:** If the installation just finished, you might need to exit the SSH session and reconnect to refresh your environment variables.

---
**Enjoy your personal AI Agent! 🦞**
