#!/bin/bash
set -e

echo "🌐 Adding third-party repositories..."



# Microsoft (PowerShell)
if ! [ -f /etc/apt/sources.list.d/microsoft-prod.list ]; then
    echo "Adding Microsoft repository..."
    wget -q https://packages.microsoft.com/config/ubuntu/24.04/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb
    rm /tmp/packages-microsoft-prod.deb
fi

# Fastfetch (PPA)
if ! sudo apt-cache policy | grep -q "zhangsongcui3371/fastfetch"; then
    echo "Adding Fastfetch PPA..."
    sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
fi

echo "✅ Repositories added successfully."
