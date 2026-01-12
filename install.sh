#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "🚀 開始執行 God Mode 還原程序..."

# ------------------------------------------------------------------
# 1. 基礎連結 (Stow)
# ------------------------------------------------------------------
echo "🔗 步驟 1: 連結設定檔 (Stow)..."
MODULES=("zsh" "git" "system" "vscode")

# 檢查 vscode 目錄是否已準備好被 stow (需要先確保目標路徑結構存在)
mkdir -p "$HOME/.config/Code/User"

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
    # APT
    if [ -f "packages/apt-list.txt" ]; then
        echo "   正在更新 APT 庫..."
        sudo apt update
        echo "   正在安裝 APT 套件..."
        # xargs -a 读取文件并通过 apt install 安装
        # 為了避免錯誤中斷，我們過濾掉可能的無效包名，或者允許失敗
        # 這裡做一個簡單的迴圈或批量安裝
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