#!/bin/bash
# 🦞 OpenClaw Platform Bootstrap Script
# Unified installation logic for AWS, Oracle, and beyond.
# -------------------------------------------------------------
set -euo pipefail

# 1. Environment & Variables
# These are injected by Terraform templatefile()
USER="${USER}"
CLOUD_PROVIDER="${CLOUD_PROVIDER}"
OPENCLAW_MODEL="${OPENCLAW_MODEL}"
LLM_API_KEY="${LLM_API_KEY}"
GATEWAY_TOKEN=$(openssl rand -hex 16)
NODE_VERSION="20.x"
PNPM_VERSION="latest"

# Detect Architecture
ARCH=$(uname -m)
echo "--- 🏗️  Detected Architecture: $ARCH (Platform: $CLOUD_PROVIDER) ---"

# 2. Immediate Feedback MOTD (Setup Phase)
setup_initial_motd() {
    cat <<'DYN_MOTD' | sudo tee /etc/update-motd.d/99-openclaw > /dev/null
#!/bin/bash
USER="ubuntu"
CONFIG="/home/$USER/.openclaw/openclaw.json"
BIN="/usr/local/bin/openclaw"

echo "============================================================="
echo " 🦞 Welcome to Your OpenClaw Server! "
echo "============================================================="

if [ -f "$CONFIG" ]; then
    TOKEN=$(grep '"token":' "$CONFIG" | cut -d'"' -f4)
    if ss -tuln | grep -q ":18789"; then
        echo " ✅ OpenClaw Platform is READY"
        echo "    Join Dashboard: http://localhost:18789/#token=$TOKEN"
        echo "    👉 Run 'openclaw onboard' to set up your AI models!"
    else
        echo " ⌛ OpenClaw is STARTING..."
        echo "    Wait a moment or check: pm2 logs openclaw"
        if ! [ -x "$BIN" ]; then
            echo " ❌ ERROR: 'openclaw' binary not found at $BIN"
            echo "    Try running: find /home/$USER -name openclaw"
        fi
    fi
else
    echo " ⌛ OpenClaw is INSTALLING..."
    echo "    Setup is in progress (usually takes 10-15 mins)."
    echo "    Watch progress by running: ./check-progress.sh"
fi
echo "============================================================="
DYN_MOTD
    sudo chmod +x /etc/update-motd.d/99-openclaw
    sudo truncate -s 0 /etc/motd || true
    sudo run-parts /etc/update-motd.d/ > /run/motd.dynamic || true
}

# 3. Progress Checker Script
create_progress_checker() {
    cat <<EOF > /home/$USER/check-progress.sh
#!/bin/bash
echo "🦞 Monitoring OpenClaw installation logs..."
echo "💡 This view will automatically exit when setup is complete."
echo "💡 (Or press Ctrl+C to return to shell manually anytime)"
echo "-------------------------------------------------------------"
tail -f /var/log/cloud-init-output.log &
TAIL_PID=\$!
trap "kill \$TAIL_PID 2>/dev/null" EXIT
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
echo "👉 Run 'openclaw onboard' to finish your setup!"
echo "-------------------------------------------------------------"
EOF
    chmod +x /home/$USER/check-progress.sh
    chown $USER:$USER /home/$USER/check-progress.sh
}

# 4. System Optimization
setup_system() {
    if [ ! -f /swapfile ]; then
        sudo dd if=/dev/zero of=/swapfile bs=1M count=2048
        sudo chmod 600 /swapfile
        sudo mkswap /swapfile
        sudo swapon /swapfile
        echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
    fi
    if ! grep -q "NODE_OPTIONS" /home/$USER/.bashrc; then
        echo 'export NODE_OPTIONS="--max-old-space-size=1536"' >> /home/$USER/.bashrc
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> /home/$USER/.bashrc
    fi
    export NODE_OPTIONS="--max-old-space-size=1536"
}

# 5. Dependency Installation
install_dependencies() {
    echo iptables-persistent iptables-persistent/autosave_v4 boolean true | sudo debconf-set-selections
    echo iptables-persistent iptables-persistent/autosave_v6 boolean true | sudo debconf-set-selections
    sudo DEBIAN_FRONTEND=noninteractive apt-get update && sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y curl git build-essential net-tools unzip iptables-persistent netfilter-persistent
    curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION | sudo -E bash -
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nodejs
    sudo npm install -g pnpm@$PNPM_VERSION pm2
}

# 6. OpenClaw Installation
install_openclaw() {
    sudo -u $USER mkdir -p /home/$USER/.local/bin /home/$USER/.local/share/pnpm
    
    # Robust PATH for installation
    EXT_PATH="/usr/local/bin:/usr/bin:/bin:/home/$USER/.local/bin:/home/$USER/.npm-global/bin"
    
    sudo -u $USER env PATH="$EXT_PATH" NODE_OPTIONS="--max-old-space-size=2048" bash -c "curl -fsSL https://openclaw.ai/install.sh | bash -s -- --no-onboard"
    
    # 🔍 Find the binary (Aggressive search)
    FOUND_BIN=""
    POSSIBLE_PATHS=(
        "/home/$USER/.local/bin/openclaw"
        "/home/$USER/.npm-global/bin/openclaw"
        "/usr/local/bin/openclaw"
        "/usr/bin/openclaw"
    )
    
    for p in "${POSSIBLE_PATHS[@]}"; do
        if [ -x "$p" ]; then
            FOUND_BIN="$p"
            break
        fi
    done
    
    if [ -z "$FOUND_BIN" ]; then
        echo "⚠️  Search 2: Trying 'find' command..."
        FOUND_BIN=$(find /home/$USER -name openclaw -type f -perm -u+x | head -n 1 || true)
    fi

    if [ -n "$FOUND_BIN" ]; then
        echo "✅ Found openclaw at: $FOUND_BIN"
        sudo ln -sf "$FOUND_BIN" /usr/local/bin/openclaw
    else
        echo "❌ CRITICAL ERROR: openclaw binary not found after installation!"
        # We don't exit here so cloud-init finishes and user can debug, but service won't start.
    fi
    
    sudo -u $USER env PATH="$EXT_PATH" bash -c "pnpm store prune" || true
    sudo apt-get clean
}

# 7. OpenClaw Configuration
configure_openclaw() {
    sudo -u $USER mkdir -p /home/$USER/.openclaw
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
    if [ -x "/usr/local/bin/openclaw" ]; then
        sudo -u $USER /usr/local/bin/openclaw doctor --fix --non-interactive || true
    fi
}

# 8. Start Service
start_service() {
    if [ -x "/usr/local/bin/openclaw" ]; then
        sudo -u $USER /usr/bin/pm2 delete openclaw >/dev/null 2>&1 || true
        sudo -u $USER /usr/bin/pm2 start /usr/local/bin/openclaw --interpreter bash --name openclaw -- gateway run
        sudo -u $USER /usr/bin/pm2 save

        sudo env PATH=$PATH /usr/bin/node /usr/lib/node_modules/pm2/bin/pm2 startup systemd -u $USER --hp /home/$USER || true
        sudo systemctl enable pm2-$USER || true
        sudo systemctl start pm2-$USER || true
    else
        echo "❌ Skipping service start: openclaw binary missing."
    fi
}

# 9. Firewall
configure_firewall() {
    sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
    sudo iptables -P INPUT DROP
    sudo iptables -P FORWARD DROP
    sudo iptables -A INPUT -i lo -j ACCEPT
    sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
    sudo netfilter-persistent save
}

# --- MAIN EXECUTION ---
setup_initial_motd
create_progress_checker
setup_system
install_dependencies
install_openclaw
configure_openclaw
start_service
configure_firewall

sudo run-parts /etc/update-motd.d/ > /run/motd.dynamic || true
echo "--- 🦞 OpenClaw Bootstrap Completed for $CLOUD_PROVIDER at $(date) ---"
