#!/usr/bin/env python3

import socket
import platform
import psutil
import datetime
import os
import requests

def get_ip():
    try:
        external_ip = requests.get('https://ifconfig.me', timeout=3).text
    except:
        external_ip = 'Unavailable'

    try:
        internal_ip = socket.gethostbyname(socket.gethostname())
    except:
        internal_ip = 'Unavailable'

    return internal_ip, external_ip

def main():
    now = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    internal_ip, external_ip = get_ip()
    os_info = platform.platform()
    cpu = psutil.cpu_percent(interval=1)
    ram = psutil.virtual_memory().percent
    disk = psutil.disk_usage('/').percent
    user = os.getenv("USER") or os.getlogin()

    print("="*40)
    print(f"👤 User       : {user}")
    print(f"🕒 Date/Time  : {now}")
    print(f"💻 OS         : {os_info}")
    print(f"📡 IP (LAN)   : {internal_ip}")
    print(f"🌍 IP (WAN)   : {external_ip}")
    print(f"🧠 CPU Usage  : {cpu}%")
    print(f"📦 RAM Usage  : {ram}%")
    print(f"💽 Disk Usage : {disk}%")
    print("="*40)

if __name__ == "__main__":
    main()
