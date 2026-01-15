#!/bin/bash
set -e

# 自動偵測腳本所在目錄的父目錄作為 DOTFILES_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "🚀 開始執行系統備份... [$TIMESTAMP]"
echo "📂 Dotfiles 路徑: $DOTFILES_DIR"

# 1. 備份 APT 套件清單
echo "📦 正在匯出 APT 套件清單 (此動作會覆蓋現有清單)..."
apt-mark showmanual > "$DOTFILES_DIR/packages/apt-list.txt"

# 2. 備份 Snap 套件清單
echo "📦 正在匯出 Snap 套件清單..."
snap list | awk 'NR>1 {print $1}' > "$DOTFILES_DIR/packages/snap-list.txt"

# 3. 備份 VS Code 擴充套件
if command -v code &> /dev/null; then
    echo "📝 正在匯出 VS Code 擴充套件清單..."
    code --list-extensions > "$DOTFILES_DIR/vscode/extensions.txt"
else
    echo "⚠️  未偵測到 VS Code，跳過擴充套件備份。"
fi

# 4. 備份 GNOME 桌面設定 (WSL 跳過)
if [[ -n "$WSL_DISTRO_NAME" ]]; then
    echo "🪟 偵測到 WSL 環境，跳過 GNOME 桌面設定備份。"
else
    echo "🎨 正在匯出 GNOME 桌面設定..."
    dconf dump / > "$DOTFILES_DIR/gnome/dconf-settings.ini"
fi

echo "✅ 備份完成！"
echo "提示：別忘了執行 git add . && git commit 來儲存變更！"
