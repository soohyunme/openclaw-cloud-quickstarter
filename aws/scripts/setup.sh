#!/bin/bash
set -euo pipefail

# AWS default user for Ubuntu is 'ubuntu'
USER="ubuntu"
PROVIDER_EXTRAS=""

# Variable injection from Terraform
OPENCLAW_MODEL="${OPENCLAW_MODEL}"
LLM_API_KEY="${LLM_API_KEY}"

# Generate Gateway Token early for injection
GATEWAY_TOKEN=$(openssl rand -hex 16)

# Create a progress checker for the user
cat <<EOF > /home/$USER/check-progress.sh
#!/bin/bash
echo "🦞 Monitoring OpenClaw installation logs..."
echo "💡 This view will automatically exit when setup is complete."
echo "💡 (Or press Ctrl+C to return to shell manually anytime)"
echo "-------------------------------------------------------------"

# Start tail in background
tail -f /var/log/cloud-init-output.log &
TAIL_PID=\$!

# Ensure tail is killed if script is interrupted
trap "kill \$TAIL_PID 2>/dev/null" EXIT

# Wait for completion marker
while true; do
  if grep -q "Cloud-init .* finished" /var/log/cloud-init-output.log; then
    sleep 2
    kill \$TAIL_PID 2>/dev/null
    break
  fi
  sleep 2
done

echo -e "\n-------------------------------------------------------------"
echo "✅ INSTALLATION COMPLETE!"
echo "🚀 Your OpenClaw server is ready."
echo "🔗 Access Dashboard: http://localhost:18789/#token=$GATEWAY_TOKEN"
echo "   (Requires SSH Tunnel: ssh -L 18789:localhost:18789 ...)"
echo "👉 Run 'openclaw onboard' to finish your setup!"
echo "   (If 'openclaw' is not found, run 'source ~/.bashrc' or use its full path: ~/.local/bin/openclaw onboard)"
echo "-------------------------------------------------------------"
EOF
chmod +x /home/$USER/check-progress.sh
chown $USER:$USER /home/$USER/check-progress.sh

# 0. Setup Swap (Crucial for 1GB RAM instances)
if [ ! -f /swapfile ]; then
    sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

# 1. Optimize Node.js Memory (Crucial for micro instances)
if ! grep -q "NODE_OPTIONS" /home/$USER/.bashrc; then
    echo 'export NODE_OPTIONS="--max-old-space-size=1536"' >> /home/$USER/.bashrc
    echo 'export PATH=$PATH:/home/'$USER'/.local/bin' >> /home/$USER/.bashrc
fi
export NODE_OPTIONS="--max-old-space-size=1536" 

# 1. Update & Upgrade
export DEBIAN_FRONTEND=noninteractive
sudo apt-get update && sudo apt-get upgrade -y

# 2. Install Essentials
sudo apt-get install -y curl git build-essential net-tools unzip

# 3. Install Node.js (LTS 20.x)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt-get install -y nodejs

# Fix: Enable Corepack & pnpm manually before install
sudo corepack enable
sudo corepack prepare pnpm@latest --activate

# Permanent PATH setup for the user
if ! grep -q ".local/bin" "/home/$USER/.bashrc"; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> "/home/$USER/.bashrc"
    echo 'export PATH="$HOME/.local/share/pnpm:$PATH"' >> "/home/$USER/.bashrc"
fi
export PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/home/$USER/.local/share/pnpm:/home/$USER/.local/bin

# Fix OOM: Increase Node.js heap size
export NODE_OPTIONS="--max-old-space-size=2048"

# 4. Install OpenClaw (From Git Source) & PM2
# Note: This step is resource-intensive (pnpm install & build) and takes 10-15 mins on 1GB RAM.
sudo npm install -g pm2
sudo -u $USER env PATH=$PATH NODE_OPTIONS="--max-old-space-size=2048" bash -c "curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard"

# 4b. Ensure command is globally accessible immediately
sudo ln -sf /home/$USER/.local/bin/openclaw /usr/local/bin/openclaw

# 4c. Cleanup to save disk space
sudo -u $USER bash -c "export PATH=\$PATH:/home/$USER/.local/share/pnpm; pnpm store prune" || true
sudo apt-get clean

# 5. Configure OpenClaw (Fully Automated)
sudo -u $USER mkdir -p /home/$USER/.openclaw
# --- Platform and Gateway Configuration ---

# We only configure the Gateway access (Authentication) here.
# LLM Provider configuration is delegated to 'openclaw onboard' for maximum reliability.
cat <<EOF | sudo -u $USER tee /home/$USER/.openclaw/openclaw.json > /dev/null
{
  "gateway": {
    "mode": "local",
    "bind": "loopback",
    "auth": {
      "mode": "token",
      "token": "$GATEWAY_TOKEN"
    }
  }
}
EOF

# Automatically fix/fill provider-specific configuration (important for Moonshot/Gemini)
sudo -u $USER /home/$USER/.local/bin/openclaw doctor --fix --non-interactive

# Start OpenClaw Gateway as a service
# We start it even if no key is provided so the user can use the Dashboard onboarder.
sudo -u $USER /usr/bin/pm2 delete openclaw >/dev/null 2>&1 || true
sudo -u $USER /usr/bin/pm2 start /home/$USER/.local/bin/openclaw --interpreter bash --name openclaw -- gateway run
sudo -u $USER /usr/bin/pm2 save

# Wait and verify listening port
echo "⌛ Waiting for OpenClaw to start listening on port 18789..."
sleep 15
if ! netstat -tulnp | grep -q ":18789"; then
    echo "⚠️ OpenClaw is NOT listening on port 18789. Checking doctor..."
    sudo -u $USER /home/$USER/.local/bin/openclaw doctor --fix --non-interactive || true
    sudo -u $USER /usr/bin/pm2 restart openclaw
    sleep 10
fi

# PM2 startup setup
sudo env PATH=$PATH /usr/bin/node /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $USER --hp /home/$USER || true
sudo systemctl enable pm2-$USER || true
sudo systemctl start pm2-$USER || true

if netstat -tulnp | grep -q ":18789"; then
    STATUS_LINE=" ✅ OpenClaw Platform is READY"
    LOG_INFO="    Join Dashboard: http://localhost:18789/#token=$GATEWAY_TOKEN"
    ONBOARD_INFO="    👉 Run 'openclaw onboard' to set up your AI models!"
    HELP_TIPS="    💡 Security: Web UI is bound to localhost with a secure token."
else
    STATUS_LINE=" ❌ ERROR: OpenClaw failed to listen on port 18789"
    LOG_INFO="    Run: pm2 logs openclaw --lines 50"
    ONBOARD_INFO="    Try: openclaw doctor --fix"
    HELP_TIPS="    Common Cause: Low resources or config conflict."
fi

# 6. Configure Firewall (SSH only, Gateway via Tunnel)
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent netfilter-persistent
sudo netfilter-persistent save

# 7. Add MOTD
echo -e "\n\n" | sudo tee -a /etc/motd
echo -e "=============================================================" | sudo tee -a /etc/motd
echo -e " 🦞 Welcome to Your OpenClaw Server on Amazon Web Services! " | sudo tee -a /etc/motd
echo -e "=============================================================" | sudo tee -a /etc/motd
echo -e "$${STATUS_LINE:-Status: Unknown}" | sudo tee -a /etc/motd
echo -e "$${LOG_INFO:-}" | sudo tee -a /etc/motd
echo -e "$${ONBOARD_INFO:-}" | sudo tee -a /etc/motd
echo -e "$${HELP_TIPS:-}" | sudo tee -a /etc/motd
echo -e "=============================================================" | sudo tee -a /etc/motd

echo "--- Setup Completed at $(date) ---"
