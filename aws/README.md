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
- **Compute:** `t3.micro` (2 vCPU, 1GB RAM) - Universal Free Tier.
- **Fixed IP:** Elastic IP (EIP) attached to the instance.
- **Network:** Dedicated VPC with a public subnet and Internet Gateway.
- **Security:** Security Group rules for SSH (22). **Access to OpenClaw (18789) is restricted via SSH Tunneling.**
- **Automation:** User Data script to install Node.js, PM2, and OpenClaw bound to localhost.

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

Once deployment is complete (approx. 15-20 minutes), SSH into your server:

1.  **Open Cloud Shell** (if not already open).
2.  **SSH Command:**
    ```bash
    ssh -i ~/.ssh/id_rsa ubuntu@<YOUR_INSTANCE_IP>
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
*   **pm2 command not found:** If the installation just finished, you might need to refresh your environment: `source ~/.bashrc`.
*   **"Control UI requires device identity":** If you see this, ensure you are using the **SSH Tunnel** (Method 2) and accessing via `http://localhost:18789`.

## 📝 Notes on Free Tier
*   **Instance Type:** This template defaults to `t3.micro` for maximum compatibility with the AWS 12-month Free Tier.
*   **Public IP (EIP):** Includes one Elastic IP. AWS provides 750 hours of public IPv4 for free per month during the first 12 months.
*   **Region:** Free Tier rules can vary by region. **Always check the "Free Tier eligible" tag in your AWS Console** before launching.

---
**Enjoy your personal AI Agent! 🦞**
