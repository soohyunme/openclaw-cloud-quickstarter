#!/bin/bash
set -euo pipefail

# User injected via Terraform
USER="${USER}"

# 0. Setup Swap
if [ ! -f /swapfile ]; then
    sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# 1. Update & Upgrade
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update && sudo apt-get upgrade -y

# 2. Install Essentials
sudo apt-get install -y curl git build-essential net-tools unzip

# 3. Install Node.js (LTS 20.x)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Fix: Enable Corepack & pnpm
sudo corepack enable
sudo corepack prepare pnpm@latest --activate

# Permanent PATH setup
if ! grep -q ".local/bin" "/home/$USER/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "/home/$USER/.bashrc"
    echo 'export PATH="$HOME/.local/share/pnpm:$PATH"' >> "/home/$USER/.bashrc"
fi
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/home/$USER/.local/share/pnpm:/home/$USER/.local/bin

# Fix OOM: Increase Node.js heap size
export NODE_OPTIONS="--max-old-space-size=2048"

# 4. Install OpenClaw & PM2
sudo npm install -g pm2
sudo -u $USER env PATH=$PATH NODE_OPTIONS="--max-old-space-size=2048" bash -c "curl -fsSL https://openclaw.ai/install.sh | bash -s -- --install-method git --no-onboard"

# 5. Configure OpenClaw
sudo -u $USER mkdir -p /home/$USER/.openclaw

sudo -u $USER bash -c "cat <<EOF > /home/$USER/.openclaw/openclaw.json
{
  \"gateway\": {
    \"mode\": \"local\",
    \"bind\": \"auto\",
    \"auth\": {
      \"mode\": \"token\",
      \"token\": \"openclaw-token-\$(openssl rand -hex 16)\"
    }
  },
  \"models\": {
    \"providers\": {
      \"anthropic\": {
        \"apiKey\": \"${LLM_API_KEY}\"
      }
    }
  },
  \"agents\": {
    \"defaults\": {
      \"model\": {
        \"primary\": \"anthropic/${OPENCLAW_MODEL}\"
      }
    }
  }
}
EOF"

# Start OpenClaw Gateway as a service only if API Key is provided
if [[ "${LLM_API_KEY}" != "none" && -n "${LLM_API_KEY}" ]]; then
  sudo -u $USER pm2 start /home/$USER/.local/bin/openclaw --name openclaw -- gateway run
  sudo -u $USER pm2 save
  sudo env PATH=$PATH /usr/bin/node /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $USER --hp /home/$USER
  sudo systemctl start pm2-$USER
  STATUS_LINE=" ✅ OpenClaw is RUNNING (Managed by PM2)"
  LOG_INFO="    Check logs: pm2 logs openclaw"
else
  STATUS_LINE=" ⚠️ OpenClaw is INSTALLED but NOT STARTED"
  LOG_INFO="    Action: Edit ~/.openclaw/openclaw.json then run 'pm2 start openclaw'"
fi

# 6. Firewall
sudo iptables -A INPUT -p tcp --dport 18789 -j ACCEPT
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent netfilter-persistent
sudo netfilter-persistent save

# 7. Add MOTD
echo -e "\n\n" | sudo tee -a /etc/motd
echo -e "=============================================================" | sudo tee -a /etc/motd
echo -e " 🦞 Welcome to Your OpenClaw Server on Microsoft Azure! " | sudo tee -a /etc/motd
echo -e "=============================================================" | sudo tee -a /etc/motd
echo -e "$${STATUS_LINE}" | sudo tee -a /etc/motd
echo -e "$${LOG_INFO}" | sudo tee -a /etc/motd
echo -e "=============================================================" | sudo tee -a /etc/motd
