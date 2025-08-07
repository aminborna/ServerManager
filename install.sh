#!/bin/bash
# 📦 Auto Installer for ServerManager

echo "📦 Installing required packages..."
apt update && apt install -y curl sudo btop ncdu ufw python3 python3-pip

# 🔽 Download ServerManager.sh
cd /root || exit
curl -sSL https://raw.githubusercontent.com/aminborna/ServerManager/main/ServerManager.sh -o ServerManager.sh
chmod +x ServerManager.sh

# 🔽 Download info.py
curl -sSL https://raw.githubusercontent.com/aminborna/ServerManager/main/info.py -o /root/info.py
chmod +x /root/info.py
echo "✅ info.py added."

# 🔽 Download install_marzban_ssl.sh
curl -sSL https://raw.githubusercontent.com/aminborna/ServerManager/main/install_marzban_ssl.sh -o /root/install_marzban_ssl.sh
chmod +x /root/install_marzban_ssl.sh
echo "✅ install_marzban_ssl.sh added."

# 🐍 Setup Python pip and install required libraries
echo "📚 Installing Python libraries: psutil, requests..."
python3 -m ensurepip --upgrade
python3 -m pip install --upgrade pip
python3 -m pip install psutil requests

# 🔁 Add xtop alias if not exists
if ! grep -q "alias xtop=" ~/.bashrc; then
  echo "alias xtop='bash /root/ServerManager.sh'" >> ~/.bashrc
  echo "✅ xtop alias added to ~/.bashrc"
fi

# 🔁 Add bash install.sh shortcut
if ! grep -q "alias installmanager=" ~/.bashrc; then
  echo "# Run installer manually" >> ~/.bashrc
  echo "alias installmanager='bash /root/install.sh'" >> ~/.bashrc
  echo "✅ installmanager alias added."
fi

# 🔁 Reload bashrc
source ~/.bashrc 2>/dev/null

# ✅ Final message
echo "✅ Installation complete!"
echo "▶️  You can now run Server Manager using: xtop"
echo ""
echo "🚀 Launching Server Manager..."
bash /root/ServerManager.sh
