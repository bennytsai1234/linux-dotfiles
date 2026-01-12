#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")

echo "🚀 開始執行系統備份... [$TIMESTAMP]"

# 1. 備份 APT 套件清單
echo "📦 正在匯出 APT 套件清單..."
apt-mark showmanual > "$DOTFILES_DIR/packages/apt-list.txt"

# 2. 備份 Snap 套件清單
echo "📦 正在匯出 Snap 套件清單..."
snap list | awk 'NR>1 {print $1}' > "$DOTFILES_DIR/packages/snap-list.txt"

# 3. 備份 VS Code 擴充套件
if command -v code &> /dev/null; then
    echo "📝 正在匯出 VS Code 擴充套件清單..."
    code --list-extensions > "$DOTFILES_DIR/vscode/extensions.txt"
    
    # 複製設定檔以便 Stow 管理 (如果還沒做過連結)
    # 注意：這裡我們假設使用者想把現有的 VS Code 設定納入 Dotfiles 管理
    # 我們將它們移動到 dotfiles/vscode 並準備用 Stow 連結
    # 但為了安全，如果 dotfiles 裡已經有檔案，我們就不覆蓋，避免備份腳本意外重置設定
    # 這裡主要是更新清單。設定檔的同步靠 Stow 的符號連結實時生效。
else
    echo "⚠️  未偵測到 VS Code，跳過擴充套件備份。"
fi

# 4. 備份 GNOME 桌面設定 (Dconf)
# 這裡我們只備份關鍵路徑，避免匯入時造成系統不穩，或者選擇備份完整路徑但小心還原
echo "🎨 正在匯出 GNOME 桌面設定..."
dconf dump / > "$DOTFILES_DIR/gnome/dconf-settings.ini"

echo "✅ 備份完成！"
echo "📂 所有清單已更新至 $DOTFILES_DIR"
echo "提示：別忘了執行 git add . && git commit 來儲存變更！"
