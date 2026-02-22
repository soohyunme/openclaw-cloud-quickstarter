# 🦞 OpenClaw Oracle Starter (Always Free)

Create your own **OpenClaw AI Agent** on **Oracle Cloud Infrastructure (OCI)** in minutes.
This Terraform template provisions a **Free Tier (Always Free)** compatible VM (ARM Ampere A1) and automatically installs:
1.  **OpenClaw:** The AI agent platform
2.  **Node.js & PM2:** Process management and runtime environment

---

## 🚀 Quick Start (Two-Phase Setup)

CloudShell sessions are temporary. To avoid losing your files, we use a **Two-Phase** approach: **Build** in the cloud, then **Control** from your local machine.

---

### 🟢 Phase 1: In OCI Cloud Shell (Infrastructure)

1.  **Open [Oracle Cloud Shell](https://cloud.oracle.com/)** by clicking the terminal icon (`>_`) in the top right.
2.  **Clone this repository:**
    ```bash
    git clone https://github.com/soohyunme/openclaw-cloud-quickstarter.git
    cd openclaw-cloud-quickstarter/oracle
    ```
3.  **Set your authentication variables:**
    *(Get these from your OCI User Settings/API Keys page)*
    ```bash
    export TF_VAR_tenancy_ocid="ocid1.tenancy..."
    export TF_VAR_user_ocid="ocid1.user..."
    export TF_VAR_fingerprint="xx:xx:xx..."
    export TF_VAR_private_key_path="~/.oci/oci_api_key.pem"
    export TF_VAR_region="your-region-1"
    export TF_VAR_compartment_ocid="ocid1.compartment..."
    export TF_VAR_ssh_public_key="ssh-rsa AAAA..."
    export TF_VAR_llm_api_key="your-api-key-here"
    ```
4.  **Deploy! 🏗️**
    ```bash
    terraform init
    terraform plan    # Recommended: Review what will be created
    terraform apply -auto-approve
    ```
5.  **📥 DOWNLOAD CRITICAL FILES NOW!**
    Use the Cloud Shell **"Actions" > "Download File"** menu (top right) to save these to your local PC:
    - `.ssh/id_rsa` (If you generated a key) or your private key file
    - `openclaw-cloud-quickstarter/oracle/terraform.tfstate` (Required to manage/delete later)

> [!CAUTION]
> **Do not skip Step 5.** If your session expires, the `terraform.tfstate` file is deleted from the cloud, and you will not be able to update or delete your instance later.

---

### 🔵 Phase 2: On Your Local PC (Access & Monitoring)

Now that the instance is up, you can move to your local computer's terminal (Mac, Linux, or WSL).

1.  **Set Permissions:**
    - **Linux/Mac:**
      ```bash
      chmod 400 your_private_key.pem
      ```
    - **Windows (PowerShell):**
      ```powershell
      icacls .\your_private_key.pem /inheritance:r
      icacls .\your_private_key.pem /grant:r "$($env:username):R"
      ```
2.  **Create SSH Tunnel & Connect:**
    Run this command and **keep it running**:
    ```bash
    ssh -i ./your_private_key.pem -L 18789:localhost:18789 ubuntu@<YOUR_INSTANCE_IP>
    ```
    *(The IP address is shown in the Terraform output in Phase 1.)*

3.  **Monitor Installation (In the session above):**
    OpenClaw takes ~15 mins to install. Run this inside the SSH window to monitor:
    ```bash
    ./check-progress.sh
    ```

4.  **Access the Dashboard:**
    Once complete, open your browser to:
    `http://localhost:18789`

---

## 📊 Management & Monitoring

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

### 🧹 Clean Up (Destroy)
To remove all resources and stop billing (if any):
```bash
export TF_VAR_llm_api_key="none" # Skip key prompt
terraform destroy
```

> [!TIP]
> To skip the confirmation prompt during cleanup, use: `terraform destroy -auto-approve`

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
    4.  **Copy the FULL URL** (e.g., `http://localhost:18789/#token=...`) and paste it into your browser. This bypasses the session conflict.
    5.  If it still asks for a token, you can generate one manually on the server:
        ```bash
        openclaw doctor --generate-gateway-token
        ```

---
**Enjoy your personal AI Agent! 🦞**
