#!/bin/bash

clear

# 🌐 Info Block
ip_address=$(curl -s ifconfig.me)
username=$(whoami)
datetime=$(date '+%Y-%m-%d %H:%M:%S')
os_info=$(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')

echo "============================================"
echo "🛠️  Server Manager - by aminborna"
echo "GitHub: https://github.com/aminborna"
echo "Version: 2.1.0 - Full Admin Utility"
echo "============================================"
echo "📍 IP Address : $ip_address"
echo "👤 Username   : $username"
echo "📅 Date/Time  : $datetime"
echo "💻 OS         : $os_info"
echo "============================================"

# while true; do
# done
  echo ""
  echo "========= SSH & Firewall ========="
  echo "1) 🔧 Change SSH Port"
  echo "2) 🔐 Install UFW Firewall"
  echo "3) ❌ Remove UFW Firewall"
  echo ""
  echo "========= System Tools ========="
  echo "4) 📊 Show System Stats (btop)"
  echo "5) 📁 View SSH Logs"
  echo "6) 🔍 Check Service Status"
  echo "7) ⬆️  Update System"
  echo "8) 🚀 Optimize TCP & Network Performance"
  echo "9) 🔄 Reboot Server"
  echo ""
  echo "========= Control Panels ========="
  echo "10) ➕ Install Control Panel (XUI)"
  echo "11) ➕ Install Control Panel (SUI)"
  echo "12) ➕ Install Control Panel (Marzban)"
  echo ""
  echo "========= Panel Removal ========="
  echo "13) 🧹 Remove Control Panel (XUI)"
  echo "14) 🧹 Remove Control Panel (SUI)"
  echo "15) 🧹 Remove Control Panel (Marzban)"
  echo ""
echo "======== SSL & Info ========"
echo "16) 🛡 Install SSL for Marzban"
echo "17) 📊 Run Python Info Script"
echo ""
echo "0) ❌ Exit"
  echo "============================================"
  read -p "Select an option: " opt

  case $opt in
1)
      read -p "🛠️ Enter the new SSH port: " new_port
      sed -i "s/^#\?\s*Port .*/Port $new_port/" /etc/ssh/sshd_config

      if command -v ufw &>/dev/null && ufw status | grep -q active; then
        echo "🌐 UFW is active. Allowing the new SSH port $new_port..."
        ufw allow $new_port
        ufw reload
      fi

      echo "🔄 Restarting SSH service..."
      systemctl restart sshd

      echo "✅ SSH port changed to $new_port."
      echo "⌛ Waiting 40 seconds before rebooting the server..."
      echo "⚠️ Make sure port $new_port is accessible before the reboot."
      
      sleep 40
      echo "🔁 Rebooting now..."
      reboot
      ;;
    2)
      apt install -y ufw
      ufw enable
      ufw allow OpenSSH
      echo "✅ UFW Firewall installed and SSH allowed."
      ;;
    3)
      ufw disable
      apt remove --purge -y ufw
      echo "🗑️  UFW Firewall removed."
      ;;
    4)
      btop
      ;;
    5)
      journalctl -u ssh --no-pager
      ;;
    6)
      systemctl status
      ;;
    7)
      apt update && apt upgrade -y
      echo "✅ System updated."
      ;;
    8)
      sysctl -w net.core.default_qdisc=fq
      sysctl -w net.ipv4.tcp_congestion_control=bbr
      echo "✅ TCP Optimization applied (BBR + fq)."
      ;;
    9)
      reboot
      ;;
    10)
      bash <(curl -Ls https://raw.githubusercontent.com/mhsanaei/3x-ui/master/install.sh)
      ;;
    11)
      bash <(curl -Ls https://raw.githubusercontent.com/alireza0/s-ui/main/install.sh)
      ;;
      12)
  echo ""
  echo "Select Marzban DB type:"
  echo "1) SQLite (Default)"
  echo "2) MariaDB"
  echo "3) MySQL"
  read -p "Select [1-3]: " dbopt
  case $dbopt in
    2)
      sudo bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/mast>
      ;;
    3)
      sudo bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/mast>
      ;;
    *)
      sudo bash -c "$(curl -sL https://github.com/Gozargah/Marzban-scripts/raw/mast>
      ;;
  esac
  ;;
    13)
      docker rm -f x-ui && docker rmi $(docker images | grep x-ui | awk '{print $3}')
      echo "✅ XUI panel removed."
      ;;
    14)
      docker rm -f sui && docker rmi $(docker images | grep sui | awk '{print $3}')
      echo "✅ SUI panel removed."
      ;;
     15)
  echo " Looking for Marzban containers..."
  marzban_containers=$(docker ps -aqf "ancestor=gozargah/marzban")
  if [ -n "$marzban_containers" ]; then
    echo "?? Stopping and removing containers..."
    docker stop $marzban_containers
    docker rm $marzban_containers
  else
    echo "⚠️ No Marzban containers found."
  fi
  echo "?? Removing Marzban images..."
  marzban_images=$(docker images | grep marzban | awk '{print $3}' | sort | uniq)
  for img in $marzban_images; do
    echo "➡️ Removing image: $img"
    docker rmi -f $img
  done
  echo "✅  Marzban panel fully removed."
  ;;
    16) bash install_marzban_ssl.sh
    ;;
    17)
      clear
      if [ -f "./info.py" ]; then
        echo "▶️ Running info.py ..."
        python3 ./info.py
      else
        echo "❌ info.py not found in current directory."
      fi
      ;;
    0)
      echo "👋 Exiting... Goodbye!"
      exit 0
      ;;
    *)
      echo "❌ Invalid option. Please choose a valid number."
      ;;
  esac
