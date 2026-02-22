# 🦞 OpenClaw AWS Starter

Create your own **OpenClaw AI Agent** on **Amazon Web Services (AWS)** in minutes.
This Terraform template provisions a **Free Tier (12 Months)** compatible EC2 Instance and automatically installs:
1.  **OpenClaw:** The AI agent platform
2.  **Node.js & PM2:** Process management and runtime environment

---

## 🚀 Quick Start (Two-Phase Setup)

CloudShell sessions are temporary. To avoid losing your files, we use a **Two-Phase** approach: **Build** in the cloud, then **Control** from your local machine.

---

### 🟢 Phase 1: In AWS CloudShell (Infrastructure)

1.  **Open [AWS CloudShell](https://console.aws.amazon.com/cloudshell/home)** in your preferred region.
2.  **Install Terraform** (Required once per session):
    ```bash
    wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip
    unzip terraform_1.9.0_linux_amd64.zip
    sudo mv terraform /usr/bin/
    ```
3.  **Clone this repository:**
    ```bash
    git clone https://github.com/soohyunme/openclaw-cloud-quickstarter.git
    cd openclaw-cloud-quickstarter/aws
    ```
4.  **Generate SSH Key** (If you don't have one):
    ```bash
    ssh-keygen -t rsa -f ~/.ssh/id_rsa -N ""
    ```
5.  **Set your API Key:**
    ```bash
    export TF_VAR_llm_api_key="your-api-key-here"
    ```
6.  **Deploy! 🏗️**
    ```bash
    terraform init
    terraform apply
    ```
    Type **yes** when prompted.

> [!TIP]
> To skip the confirmation prompt, you can use `terraform apply -auto-approve`.

7.  **📥 DOWNLOAD CRITICAL FILES NOW!**
    Use the CloudShell **"Actions" > "Download File"** menu (top right) to save these to your local PC:
    - `.ssh/id_rsa` (Your private key)
    - `openclaw-cloud-quickstarter/aws/terraform.tfstate` (Required to manage/delete later)

> [!CAUTION]
> **Do not skip Step 7.** If your CloudShell session expires, these files are deleted from the cloud, and you will lose control of your instance.

---

### 🔵 Phase 2: On Your Local PC (Access & Monitoring)

Now that the instance is running, you can move to your local computer's terminal (Mac, Linux, or WSL).

1.  **Find your Downloads folder** (or where you saved the files).
2.  **Set Key Permissions:**
    - **Linux/Mac:**
      ```bash
      chmod 400 id_rsa
      ```
    - **Windows (PowerShell):**
      ```powershell
      icacls .\id_rsa /inheritance:r
      icacls .\id_rsa /grant:r "$($env:username):R"
      ```
3.  **Create SSH Tunnel & Connect:**
    Run this command and **keep it running**:
    ```bash
    ssh -i ./id_rsa -L 18789:localhost:18789 ubuntu@<YOUR_INSTANCE_IP>
    ```
    *(The IP address is shown in the Terraform output in Phase 1.)*

4.  **Monitor Installation (In the SSH window above):**
    OpenClaw takes ~15 mins to install. Run this inside the SSH session to watch:
    ```bash
    ./check-progress.sh
    ```

5.  **Access the Dashboard:**
    Once progress reaches 100%, **copy the full access link (including the #token=... part)** shown in your terminal and paste it into your browser:
    `http://localhost:18789/#token=...`

---

## 📊 Management & Monitoring

### 🪄 The Onboarding Wizard (Advanced Setup)

Want to connect **Discord**, **Telegram**, or change your agent's **Persona**? Run the interactive wizard inside your SSH session (the terminal from Phase 2):

```bash
openclaw onboard
```
> [!TIP]
> If the command is not found, run `source ~/.bashrc` first or use the full path: `~/.local/bin/openclaw onboard`.

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

## 📝 Notes on Free Tier
*   **Instance Type:** This template defaults to `t3.micro` for maximum compatibility with the AWS 12-month Free Tier.
*   **Public IP (EIP):** Includes one Elastic IP. AWS provides 750 hours of public IPv4 for free per month during the first 12 months.
*   **Region:** Free Tier rules can vary by region. **Always check the "Free Tier eligible" tag in your AWS Console** before launching.

---
**Enjoy your personal AI Agent! 🦞**
