# 🦞 OpenClaw Cloud Quickstarter

🚀 **The fastest way to deploy your own AI Agent on any cloud.**

This repository provides **one-click deployment templates** (Terraform) to set up a fully configured OpenClaw environment on major cloud providers.

## ✨ Supported Clouds

| Cloud Provider | Cost (Free Tier) | Specs | Guide |
| :--- | :--- | :--- | :---: |
| **[Oracle Cloud](./oracle)** | **Lifetime Free** | 4 vCPU / 24GB RAM | [📖 Start Guide](./oracle) |
| **[AWS](./aws)** | 12 Months Free | 2 vCPU / 1GB RAM | [📖 Start Guide](./aws) |

---

## 🛡️ Security & Ports
The following ports are automatically opened for your convenience:

| Port | Protocol | Service | Description |
| :--- | :---: | :--- | :--- |
| **22** | SSH | System Access | Secure Shell access |
| **18789** | TCP | **OpenClaw** | Gateway WebSocket |

> **Note:** Ports 80, 443, 8080 (Web IDE), and 3000 are NOT opened by default to minimize attack surface.

## 🎯 Why use this?
- **Zero Config:** Automatically installs Node.js, OpenClaw, and dependencies.
- **Secure by Default:** Firewall configured, tags added for management.
- **Cost Effective:** Optimized for Free Tier usage.
- **Customizable:** Change instance types and resource names via Terraform variables.
- **Beginner Friendly:** Step-by-step guides for each cloud provider.

## 🚀 Getting Started
Choose your preferred cloud provider from the table above and follow the guide!

### Example: Oracle Cloud (Recommended for Free Tier)
1. Go to the **[Oracle Quickstart Guide](./oracle)**.
2. Launch Cloud Shell.
3. Run `terraform apply` and type **yes** when prompted.
4. Enjoy your free 4 OCPU / 24GB RAM agent!

---
**Contributions are welcome!** Feel free to submit a PR for other cloud providers.
