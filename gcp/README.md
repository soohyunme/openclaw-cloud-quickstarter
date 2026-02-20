# 🦞 OpenClaw GCP Starter

Create your own **OpenClaw AI Agent** on **Google Cloud Platform (GCP)** in minutes.
This Terraform template provisions a **Free Tier (Always Free)** compatible VM (`e2-micro`) and automatically installs:
1.  **OpenClaw:** The AI agent platform
2.  **Node.js & PM2:** Process management and runtime environment

---

## 🚀 Quick Start (Using Google Cloud Shell)

The easiest way to deploy is using **Cloud Shell** (a free terminal in your browser). No local installation required!

### 1. Open Cloud Shell
1.  Log in to the [Google Cloud Console](https://console.cloud.google.com/).
2.  Select or create a new project.
3.  Click the **Activate Cloud Shell** icon (`>_`) in the top-right header.

### 2. Set Project (Required)
Make sure your project is selected in Cloud Shell:

> **Tip:** Don't know your Project ID? Run `gcloud projects list` to find it.

```bash
# Replace with your actual Project ID
gcloud config set project <YOUR_PROJECT_ID>
```

### 3. Enable APIs
Make sure the Compute Engine API is enabled for your project:
```bash
gcloud services enable compute.googleapis.com
```

### 4. Download the Code
Run the following commands in Cloud Shell:
```bash
git clone https://github.com/soohyunme/openclaw-cloud-quickstarter.git
cd openclaw-cloud-quickstarter/gcp
```

### 🏗️ Default Infrastructure
By default, this template provisions:
- **Compute:** `e2-micro` (2 vCPU, 1GB RAM) - Always Free.
- **Network:** Dedicated VPC Network with a public subnet.
- **Security:** Firewall rules for SSH (22) and OpenClaw Gateway (18789).
- **Automation:** Startup script to install Node.js, PM2, and OpenClaw.

### 5. Configuration
Set your variables using `export` (simplest for Cloud Shell):

```bash
# 1. Set your GCP Project ID
export TF_VAR_project_id=$(gcloud config get-value project)

# 2. Set your LLM API Key (Anthropic or OpenAI)
# If you don't have one yet or will use Gemini/Codex login, use "none"
export TF_VAR_llm_api_key="sk-ant-..."
```

> **💡 Tip:** Advanced users can create a `terraform.tfvars` file using `nano` or `vim` for persistent configuration. See `terraform.tfvars.example`.

### 6. Deploy! 🏗️
Initialize Terraform and apply the configuration:
```bash
terraform init
terraform apply
```
Review the execution plan. If the proposed changes are correct, type **yes** to approve and proceed with the deployment.

### ⚠️ CRITICAL: Cloud Shell Session Timeout
> [!WARNING]
> Google Cloud Shell is an **ephemeral session**. If you are idle or your browser closes, **your `terraform.tfstate` file will be PERMANENTLY LOST.**
> 
> **You MUST download the state file to your local PC immediately after `terraform apply`!**

#### 💾 How to Backup to Your Local PC:
1.  **Download State:** In Cloud Shell, click the **three dots** (top right) -> **Download File**. 
2.  **Path:** `openclaw-cloud-quickstarter/gcp/terraform.tfstate`

#### 💻 How to Connect from Your Local PC (Safe Way):
The easiest way from local PC is using the [Google Cloud SDK (gcloud)](https://cloud.google.com/sdk/docs/install):
```bash
gcloud compute ssh openclaw-server --zone=us-central1-a
```
This automatically handles your SSH keys securely.

---

Once deployment is complete (approx. 10-20 minutes), SSH into your server:

1.  **Open Cloud Shell** (if not already open).
2.  **SSH Command:**
    ```bash
    gcloud compute ssh openclaw-server --zone=<YOUR_ZONE>
    ```
3.  **Monitor Progress:**
    ```bash
    ./check-progress.sh
    ```
4.  **Verify Service:**
    Wait for setup to complete, then run:
    ```bash
    pm2 status
    ```

Once deployment is complete (approx. 5-10 minutes), connect using `gcloud`:

```bash
gcloud compute ssh openclaw-server --zone=us-central1-a
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
*   **Instance Type:** `e2-micro` is eligible for Always Free usage (in `us-west1`, `us-central1`, `us-east1`).
*   **Disk:** 30GB Standard Persistent Disk is included in Free Tier.
*   **Egress:** Network egress traffic limits apply.

---
**Enjoy your personal AI Agent! 🦞**
