#!/bin/bash
set -e

echo "🌐 Adding third-party repositories..."

# Google Chrome
if ! [ -f /etc/apt/sources.list.d/google-chrome.list ]; then
    echo "Adding Google Chrome repository..."
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
fi

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
