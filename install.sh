#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "🚀 開始執行 WSL2 純淨開發環境還原..."

# ------------------------------------------------------------------
# 0. 系統最佳化設定 (Sudo & Mirror)
# ------------------------------------------------------------------
echo "🛠️ 步驟 0: 系統最佳化設定..."

# Sudo 免密碼
if [ ! -f "/etc/sudoers.d/$USER-nopasswd" ]; then
    echo "   - 設定 $USER 免密碼 sudo..."
    echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee "/etc/sudoers.d/$USER-nopasswd" > /dev/null
    sudo chmod 0440 "/etc/sudoers.d/$USER-nopasswd"
else
    echo "   - Sudo 免密碼已設定，跳過。"
fi

# 台灣軟體源 (Mirror)
if grep -q "archive.ubuntu.com" /etc/apt/sources.list.d/ubuntu.sources 2>/dev/null; then
    echo "   - 切換至台灣鏡像站 (tw.archive.ubuntu.com)..."
    sudo sed -i 's|http://archive.ubuntu.com/ubuntu/|http://tw.archive.ubuntu.com/ubuntu/|g' /etc/apt/sources.list.d/ubuntu.sources
    sudo sed -i 's|http://security.ubuntu.com/ubuntu/|http://tw.archive.ubuntu.com/ubuntu/|g' /etc/apt/sources.list.d/ubuntu.sources
    sudo apt update
else
    echo "   - 軟體源已優化，跳過。"
fi

# ------------------------------------------------------------------
# 0.5. Zsh & Powerlevel10k 環境準備
# ------------------------------------------------------------------
echo "🐚 步驟 0.5: 準備 Zsh 環境..."

# 確保先安裝 zsh
if ! command -v zsh &> /dev/null; then
    echo "    - 系統未偵測到 Zsh，正在安裝..."
    sudo apt update && sudo apt install -y zsh
fi

# 安裝 Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "    - 安裝 Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
    sudo chsh -s $(which zsh) $USER
else
    echo "    - Oh My Zsh 已安裝，跳過。"
fi

# 安裝 Powerlevel10k
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "   - 安裝 Powerlevel10k 主題..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# 安裝 Zsh 外掛
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "   - 安裝 zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "   - 安裝 zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ------------------------------------------------------------------
# 1. 基礎連結 (Stow)
# ------------------------------------------------------------------
echo "🔗 步驟 1: 連結設定檔 (Stow)..."
# 移除了 gnome 模組
MODULES=("zsh" "git" "system" "vscode" "gemini")

mkdir -p "$HOME/.config/Code/User"
mkdir -p "$HOME/.gemini"

for module in "${MODULES[@]}"; do
    if [ -d "$module" ]; then
        echo "   - 處理模組: $module"
        stow --adopt "$module"
    fi
done
git checkout . 2>/dev/null || true

# ------------------------------------------------------------------
# 2. 開發軟體安裝 (APT)
# ------------------------------------------------------------------
echo "📦 步驟 2: 檢查開發軟體安裝 (APT Only)..."
if [ -f "packages/apt-list.txt" ]; then
     read -p "❓ 是否要安裝/更新 APT 開發套件？ (y/N) " -n 1 -r
     echo
     if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "   正在設定第三方庫..."
        chmod +x scripts/setup_repos.sh
        ./scripts/setup_repos.sh

        echo "   正在更新 APT 庫..."
        sudo apt update
        echo "   正在安裝 APT 套件..."
        # 過濾掉可能殘留的空白行
        sudo apt install -y $(cat packages/apt-list.txt | tr '\n' ' ') || echo "⚠️ 部分 APT 套件安裝失敗，請稍後手動檢查。"
     fi
fi

# ------------------------------------------------------------------
# 3. VS Code 擴充套件
# ------------------------------------------------------------------
if [ -f "vscode/extensions.txt" ] && command -v code &> /dev/null; then
    echo "🧩 步驟 3: 檢查 VS Code 擴充套件..."
    read -p "❓ 是否要安裝 VS Code 擴充套件？ (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        while read -r ext; do
            code --install-extension "$ext" --force || echo "   無法安裝: $ext"
        done < "vscode/extensions.txt"
    fi
else
    echo "ℹ️  未偵測到 'code' 指令，跳過 VS Code 擴充安裝 (請確認已安裝 Remote - WSL)。"
fi

echo "🎉 WSL2 純淨開發環境還原完成！請重新啟動終端機。"