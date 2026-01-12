#!/bin/bash

# 取得腳本所在目錄的絕對路徑
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$DOTFILES_DIR"

echo "🚀 開始安裝 Dotfiles..."

# 定義要使用的 Stow 模組
MODULES=("zsh" "git" "system")

for module in "${MODULES[@]}"; do
    echo "📦 正在連結模組: $module"
    # --adopt 會處理已存在的檔案，將其內容同步回 dotfiles 目錄
    stow --adopt "$module"
done

# 如果有使用 Git 追蹤，可以在 adopt 後恢復受控版本（避免本地微小差異覆蓋了倉庫版本）
# git checkout . 

echo "🎉 所有設定檔已成功連結！"
echo "提示：若有新增設定檔，只需放入對應目錄後再次執行此腳本即可。"
