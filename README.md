# 🦞 OpenClaw Cloud Quickstarter

🚀 **The fastest way to deploy your own AI Agent on any cloud.**

This repository provides **one-click deployment templates** (Terraform) to set up a fully configured OpenClaw environment on major cloud providers.

## ✨ Supported Clouds

| Cloud Provider | Cost (Free Tier) | Specs | Guide |
| :--- | :--- | :--- | :---: |
| **[Oracle Cloud](https://cloud.oracle.com/)** | **Lifetime Free** | 4 OCPU / 24GB RAM | [⚠️ (Coming Soon)](./oracle) |
| **[AWS](https://console.aws.amazon.com/)** | Free Tier Eligible | t3.small / 2GB RAM | [📖 Start Guide](./aws) |

> [!NOTE]
> AWS Free Tier eligibility varies by account age (e.g., 6-12 months). Check the **[Official AWS Free Tier Page](https://aws.amazon.com/free/)** for details.

---

## 🛡️ Security & Ports
The following ports are automatically opened for your convenience:

| Port | Protocol | Service | Description |
| :--- | :---: | :--- | :--- |
| **22** | SSH | System Access | Secure Shell access (Mandatory) |

> [!IMPORTANT]
> **Secure by Default**: Access to the OpenClaw Gateway (18789) is restricted to `localhost` and must be accessed via **SSH Tunneling**. This keeps your agent hidden from the public internet.

## 🎯 Why use this?
- **Zero Config:** Automatically installs Node.js, OpenClaw, and dependencies.
- **Secure by Default:** Firewall configured, tags added for management.
- **Cost Effective:** Optimized for Free Tier usage.
- **Customizable:** Change instance types and resource names via Terraform variables.
- **Beginner Friendly:** Step-by-step guides for each cloud provider.

## 🚀 Getting Started
Choose your preferred cloud provider from the table above and follow the guide!

### Example: Oracle Cloud (Recommended - Coming Soon 🚧)
1. Go to the **[Oracle Quickstart Guide](./oracle)**.
2. Launch Cloud Shell.
3. Run `terraform apply` and type **yes** when prompted.
4. **Access UI**: Run the SSH Tunnel command shown in your terminal.
5. Enjoy your free 4 OCPU / 24GB RAM agent!

---
**Contributions are welcome!** Feel free to submit a PR for other cloud providers.
