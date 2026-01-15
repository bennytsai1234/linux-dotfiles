#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "🚀 開始執行 God Mode 還原程序..."

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
if grep -q "archive.ubuntu.com" /etc/apt/sources.list.d/ubuntu.sources;
 then
    echo "   - 切換至台灣鏡像站 (tw.archive.ubuntu.com)..."
    sudo sed -i 's|http://archive.ubuntu.com/ubuntu/|http://tw.archive.ubuntu.com/ubuntu/|g' /etc/apt/sources.list.d/ubuntu.sources
    sudo sed -i 's|http://security.ubuntu.com/ubuntu/|http://tw.archive.ubuntu.com/ubuntu/|g' /etc/apt/sources.list.d/ubuntu.sources
    sudo apt update
else
    echo "   - 軟體源已優化，跳過。"
fi

# ------------------------------------------------------------------
# 1. 基礎連結 (Stow)
# ------------------------------------------------------------------
echo "🔗 步驟 1: 連結設定檔 (Stow)..."
MODULES=("zsh" "git" "system" "vscode" "gemini")

# 確保目標目錄存在
mkdir -p "$HOME/.config/Code/User"
mkdir -p "$HOME/.gemini"

for module in "${MODULES[@]}"; do
    if [ -d "$module" ]; then
        echo "   - 處理模組: $module"
        stow --adopt "$module"
    fi
done

# ------------------------------------------------------------------
# 2. 軟體安裝
# ------------------------------------------------------------------
echo "📦 步驟 2: 檢查軟體安裝..."
read -p "❓ 是否要開始安裝/更新 APT 與 Snap 軟體？這可能需要一段時間 (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    # Architecture and Repos
    echo "   正在設定架構與第三方庫..."
    sudo dpkg --add-architecture i386
    chmod +x scripts/setup_repos.sh
    ./scripts/setup_repos.sh

    # APT
    if [ -f "packages/apt-list.txt" ]; then
        echo "   正在更新 APT 庫..."
        sudo apt update
        echo "   正在安裝 APT 套件..."
        sudo apt install -y $(cat packages/apt-list.txt | tr '\n' ' ') || echo "⚠️ 部分 APT 套件安裝失敗，請稍後手動檢查。"
    fi

    # Snap
    if [ -f "packages/snap-list.txt" ]; then
        echo "   正在安裝 Snap 套件..."
        while read -r snap_pkg; do
            sudo snap install "$snap_pkg" --classic 2>/dev/null || echo "   (已安裝或跳過: $snap_pkg)"
        done < "packages/snap-list.txt"
    fi
fi

# ------------------------------------------------------------------
# 3. VS Code 擴充套件
# ------------------------------------------------------------------
if [ -f "vscode/extensions.txt" ] && command -v code &> /dev/null; then
    echo "🧩 步驟 3: 安裝 VS Code 擴充套件..."
    while read -r ext; do
        code --install-extension "$ext" --force || echo "   無法安裝: $ext"
    done < "vscode/extensions.txt"
fi

# ------------------------------------------------------------------
# 4. GNOME 設定還原
# ------------------------------------------------------------------
if [ -f "gnome/dconf-settings.ini" ] && command -v dconf &> /dev/null; then
    echo "🎨 步驟 4: 還原 GNOME 桌面設定..."
    read -p "❓ 確定要覆蓋目前的桌面設定 (Dconf) 嗎？ (y/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        dconf load / < "gnome/dconf-settings.ini"
        echo "   已匯入設定。"
    fi
fi

echo "🎉 God Mode 還原完成！請重新啟動終端機或登出登入以套用所有變更。"
