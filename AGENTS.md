# OpenClaw Cloud Quickstarter: Comprehensive Technical Summary

## 📋 Project Overview
- **Name:** `openclaw-cloud-quickstarter`
- **Core Mission:** Enable anyone to deploy a production-ready OpenClaw AI Agent on top-tier cloud infrastructure in under 10 minutes, leveraging "Always Free" and "Free Tier" resources.
- **Target Audience:** Developers, AI enthusiasts, and cloud beginners who want a private, secure, and cost-effective environment for their AI agents.

## 🏗️ Multi-Cloud Strategy & Instance Specs
Each cloud provider is configured to use the best possible free resources:

| Provider | Instance Type | Specs | Benefit |
| :--- | :--- | :--- | :--- |
| **Oracle (OCI)** | `VM.Standard.A1.Flex` | 4 OCPU, 24GB RAM | Most powerful free tier (ARM64). |
| **Google (GCP)** | `e2-micro` | 2 vCPU, 1GB RAM | Reliable "Always Free" (x86_64). |
| **AWS** | `t3.micro` | 2 vCPU, 1GB RAM | 12-Month Free Tier standard. |
| **Azure** | `Standard_B1s` | 1 vCPU, 1GB RAM | 12-Month Free Tier entry. |

## 🛠️ Key Technical Architecture

### 1. "Zero-Config" Philosophy
- **Environment Variables:** No manual editing of `.tf` or `.json` files required. Users simply `export TF_VAR_llm_api_key="..."` in their terminal.
- **Cloud-Init / Startup Scripts:** Custom bash scripts (`setup.sh`) handle 100% of the post-boot configuration:
    - OS update and security patching.
    - Installation of Node.js (LTS) via official repositories.
    - Global installation of `openclaw` and `pm2`.
    - Automated generation of `~/.openclaw/config.json`.
    - Service persistence via PM2 and Systemd.

### 2. Hardened Security Posture
- **Minimal Attack Surface:** After technical review, we restricted open ports to the absolute minimum:
    - **Port 22 (SSH):** For administrative access.
    - **Port 18789 (OpenClaw Gateway):** For secure WebSocket communication.
- **Intentional Removal of Web IDE:** `code-server` was removed to prevent unauthorized access via browser and to save precious RAM on 1GB instances.
- **Firewall Management:** Automated configuration of OCI Security Lists, AWS Security Groups, GCP Firewall Rules, and Azure NSGs.

### 3. Cloud-Specific Innovations
- **AWS Region Auto-detection:** README guides users to use `$AWS_REGION` to ensure resources are created in the current Cloud Shell region.
- **AWS Key-Pair Management:** Integrated `ssh-keygen` workflow to avoid manual console interactions while maintaining private key security (key stays on local/shell).
- **GCP Metadata Integration:** Uses GCP's internal metadata server to pass sensitive API keys to the startup script.
- **OCI Availability Domain Logic:** Dynamic lookup of ADs to ensure compatibility across different tenancies.

## 📁 Repository Organization
```text
openclaw-cloud-quickstarter/
├── README.md               # Unified landing page with cloud comparison table
├── .gitignore              # Strict rules to prevent leaking tfstate or secret keys
├── oracle/                 # Oracle Cloud: High-performance ARM templates
├── aws/                    # AWS: Highly available VPC/EC2 templates
├── gcp/                    # GCP: Lean e2-micro templates with metadata injection
└── azure/                  # Azure: Standard VNET/VM templates
```

## 🚀 Deployment Workflow (The "Happy Path")
1. **Prepare:** Access Cloud Shell of the chosen provider.
2. **Environment:** Set `TF_VAR_llm_api_key` (and `project_id` for GCP).
3. **Provision:** `terraform init && terraform apply`.
4. **Finalize:** Wait 5-10 minutes for the `setup.sh` to complete.
5. **Verify:** SSH in and run `pm2 status` to see the "Online" status.

## ⚠️ Known Challenges & Troubleshooting
- **OCI Capacity:** "Out of Host Capacity" is common for A1.Flex. Users are advised to try different ADs or regions.
- **GCP Billing:** Even for "Always Free", users must link a billing account to enable the Compute Engine API.
- **AWS/Azure Expiry:** Explicit warnings included about the 12-month limit to prevent surprise billing.

## 🛡️ Safety & Guardrails (STRICT)
- **NO AUTOMATED APPLY:** Agents must NEVER execute `terraform apply`, `aws` resource mutations, or `git push` without explicit, per-command user confirmation.
- **READ-ONLY VERIFICATION:** All infrastructure checks must use `terraform plan`, `terraform validate`, or `aws ... --dry-run`.
- **STATE INTEGRITY:** Never manually edit `terraform.tfstate`. Always use `terraform import` or `terraform state` commands for adjustments.

---
*Maintained by Oracle (Cloud Senior Engineer Agent)*
*Updated: 2026-02-20*
