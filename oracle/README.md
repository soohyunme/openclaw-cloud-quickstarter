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
- **Security:** Ingress rules for SSH (22). **Access to OpenClaw (18789) is restricted via SSH Tunneling.**
- **Automation:** Automated installation of Node.js, PM2, and OpenClaw bound to localhost.

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

### ⚠️ CRITICAL: Cloud Shell Session Timeout
> [!WARNING]
> OCI Cloud Shell is an **ephemeral session**. If you are idle or your browser closes, **your `terraform.tfstate` file will be PERMANENTLY LOST.**
> 
> **You MUST download the state file to your local PC immediately after `terraform apply`!**

#### 💾 How to Backup to Your Local PC:
1.  **Download State:** In Cloud Shell, click **Actions** (top right) -> **Download File**. 
2.  **Path:** `openclaw-cloud-quickstarter/oracle/terraform.tfstate`
3.  **Private Key:** Ensure you also have the private key corresponding to the public key you provided in `TF_VAR_ssh_public_key`.

#### 💻 How to Connect from Your Local PC (Safe Way):
1.  **Set Permissions (Required):** `chmod 400 your_private_key.pem`
2.  **SSH Command:**
    ```bash
    ssh ubuntu@<YOUR_INSTANCE_IP>
    ```

Once deployment is complete (approx. 10-20 minutes), SSH into your server:

1.  **Open Cloud Shell** (if not already open).
2.  **SSH Command:**
    ```bash
    ssh ubuntu@<YOUR_INSTANCE_IP>
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

## 🎉 Finalizing Setup

### 🪄 Access the Web UI (Securely)
OpenClaw is bound to `localhost` for maximum security. To access the web interface from your local computer:

1.  **Open a new terminal** on your local machine.
2.  **Run the SSH Tunnel command** (point to your downloaded `id_rsa` file):
    ```bash
    ssh -i ./id_rsa -L 18789:localhost:18789 ubuntu@<YOUR_INSTANCE_IP>
    ```
    *(Note: If the command fails, make sure you are in the folder where you downloaded `id_rsa`, usually your **Downloads** folder.)*
3.  **Open your browser** and go to: `http://localhost:18789`
4.  **Profit!** This method bypasses "Secure Context" errors and keeps your gateway hidden from the public internet.

### 🪄 The Onboarding Wizard
Connect messaging channels (Discord/Telegram), or change your persona:
```bash
openclaw onboard
```

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
*   **"Out of Host Capacity" Error:** Oracle Free Tier ARM instances are popular and sometimes out of stock. Retry later or try another availability domain.
*   **pm2 command not found:** If the installation just finished, refresh your environment: `source ~/.bashrc`.
*   **"Control UI requires device identity" or "device token mismatch":**
    1.  Ensure you are using the **SSH Tunnel** (Method 2) via `http://localhost:18789`.
    2.  If the error persists, clear your browser's local storage/cookies for `localhost:18789`.
    3.  Alternatively, run this on the server to get a fresh login URL:
        ```bash
        openclaw dashboard --no-open
        ```
    4.  If it still asks for a token, you can generate one manually on the server:
        ```bash
        openclaw doctor --generate-gateway-token
        ```

---
**Enjoy your personal AI Agent! 🦞**
