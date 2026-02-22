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
    ```
4.  **Deploy! 🏗️**
    ```bash
    terraform init
    terraform apply
    ```
    Type **yes** when prompted.

> [!TIP]
> To skip the confirmation prompt, you can use `terraform apply -auto-approve`.

5.  **📥 DOWNLOAD CRITICAL FILES NOW!**
    Use the Cloud Shell **"Actions" > "Download File"** menu (top right) to save these to your local PC:
    - `.ssh/id_rsa` (If you generated a key) or your private key file
    - `openclaw-cloud-quickstarter/oracle/terraform.tfstate` (Required to manage/delete later)

> [!CAUTION]
> **Do not skip Step 5.** If your session expires, the `terraform.tfstate` file is deleted from the cloud, and you will not be able to update or delete your instance later.

---

### 🔵 Phase 2: Finish Setup (Onboarding)

Once infrastructure is deployed, you must run the official onboarding wizard to configure your AI models.

1.  **Connect to your instance:**
    (Use the SSH command provided in the Terraform output)
2.  **Monitor installation:**
    ```bash
    ./check-progress.sh
    ```
3.  **Run Onboarding Wizard:**
    When setup is complete, run:
    ```bash
    openclaw onboard
    ```
    Follow the prompts to add your API keys (Anthropic, OpenAI, etc.). OpenClaw will handle the rest!

---

### 🟣 Phase 3: Monitoring & Control

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

    While the installation runs, notice that your **Dynamic MOTD** is already being prepared. Once complete, you can access the dashboard using the full link (with token) shown in the terminal.

---

## 📊 Management & Onboarding

### 🪄 The Onboarding Wizard
Want to connect **Discord**, **Telegram**, or change your agent's **Persona**? Run the interactive wizard inside your SSH session:

```bash
openclaw onboard
```
> [!TIP]
> **Lost your token?** Simply log in again! The **Dynamic MOTD** will show your live dashboard link and token on every login.
> [!TIP]
> If the command is not found, run `source ~/.bashrc` first or use the full path: `~/.local/bin/openclaw onboard`.

### 📊 Check Status
```bash
pm2 status
pm2 logs openclaw
```

---

### 🧹 Clean Up (Destroy)
To remove all resources and stop billing (if any):
```bash
terraform destroy
```

> [!TIP]
> To skip the confirmation prompt during cleanup, use: `terraform destroy -auto-approve`

## ⚠️ Troubleshooting
*   **"Out of Host Capacity" Error:** Oracle Free Tier ARM instances are popular and sometimes out of stock. Retry later or try another availability domain (AD).
*   **"Control UI requires device identity", "pairing required", or "device token mismatch":**
    - This is the most common issue. OpenClaw uses secure tokens for identification.
    - **Solution:** Always access the dashboard using the **Full URL with Token** (e.g., `http://localhost:18789/#token=...`).
    - If you lost your token, run this on your server:
        ```bash
        cat ~/.openclaw/gateway_token
        ```
    - Or generate a fresh login URL:
        ```bash
        openclaw dashboard --no-open
        ```
    - **Step-by-Step Recovery:**
        1.  Ensure your **SSH Tunnel** is active.
        2.  Clear your browser cookies/local storage for `localhost:18789`.
        3.  Copy/Paste the **FULL URL** from the command above into your browser.

## 📝 Notes on Free Tier
*   **Always Free ARM:** This template uses the `VM.Standard.A1.Flex` shape (4 OCPUs, 24 GB RAM for free).
    - *Tip*: You can override this by running `export TF_VAR_instance_shape="VM.Standard.E2.1.Micro"` before `terraform apply`.
*   **Quotas:** If you have other instances, you might hit your 4 OCPU limit. Ensure you have enough quota or adjust `variables.tf`.
*   **Idle Termination:** Oracle may reclaim idle instances. Keep your agent active or check [Oracle's policy](https://www.oracle.com/cloud/free/#always-free).

---
**Enjoy your personal AI Agent! 🦞**
