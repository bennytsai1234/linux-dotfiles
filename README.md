# 🚀 Linux God Mode Dotfiles (系統自動化備份與還原)

這是專為 Linux (Ubuntu 24.04+) 開發者設計的 **全自動環境管理系統**。特別針對 **AGV/機器人開發** 進行了優化，內建台灣軟體源加速、Gemini CLI 整合以及現代化的 Zsh 環境。

## ✨ 特色

- **🇹🇼 台灣在地化**：自動切換至 `tw.archive.ubuntu.com`，下載速度飛快。
- **🤖 Gemini 整合**：內建 Gemini CLI 設定與面試學習清單 (Traditional Chinese)。
- **⚡ 極速還原**：一鍵安裝 APT/Snap 軟體、還原 GNOME 設定、VS Code 外掛。
- **🐚 終端機美化**：預設啟用 Zsh + Powerlevel10k + Auto Suggestions + Syntax Highlighting。
- **🔧 開發者友善**：預設 Git Alias、Sudo 免密碼、AGV 專案快速導航。

---

## ⚡ 快速開始 (如何在「新電腦」上還原)

當你拿到一台剛重灌好的 Linux 電腦，只需執行以下步驟：

### 1. 安裝基礎工具
新電腦通常需要 Git 與 Stow：
```bash
sudo apt update && sudo apt install -y git stow
```

### 2. 下載備份
```bash
git clone https://github.com/bennytsai1234/linux-dotfiles.git $HOME/dotfiles
```

### 3. 一鍵還原 (God Mode)
```bash
cd $HOME/dotfiles
chmod +x install.sh
./install.sh
```
**腳本將自動執行以下動作：**
1. 設定 Sudo 免密碼與台灣軟體源。
2. 安裝 Oh My Zsh 與 Powerlevel10k 主題。
3. 使用 Stow 連結設定檔 (.zshrc, .gitconfig, .gemini 等)。
4. 安裝常用的開發軟體 (Build-essential, CMake, VS Code 等)。
5. 還原 VS Code 外掛與 GNOME 桌面設定。

---

## ⌨️ 常用指令與別名 (Aliases)

安裝後，您可以使用以下縮寫來加速開發：

| 指令 | 說明 | 對應原指令 |
| --- | --- | --- |
| `update` | 系統全面更新 | `sudo apt update && upgrade...` |
| `install <pkg>` | 安裝軟體 | `sudo apt install -y <pkg>` |
| `p` | 切換到 AGV 專案 | `cd ~/agv_project` |
| `d` | 切換到 Dotfiles | `cd ~/dotfiles` |
| `st` / `gs` | Git Status | `git status` |
| `lg` | Git Log (圖形化) | `git log --graph...` |
| `ls` | 列出檔案 (美化版) | `lsd` |
| `cat` | 查看檔案 (高亮版) | `batcat` |

---

## 📂 目錄結構

```
dotfiles/
├── install.sh          # 核心還原腳本
├── gemini/             # Gemini CLI 設定與學習清單
├── git/                # .gitconfig 設定
├── zsh/                # .zshrc 與 p10k 設定
├── vscode/             # VS Code 外掛清單與設定
├── gnome/              # GNOME Dconf 備份
├── system/             # 系統層級設定 (.bashrc 等)
├── packages/           # APT 與 Snap 軟體清單
└── scripts/            # 輔助腳本 (backup.sh, setup_repos.sh)
```

## 🔄 如何更新備份

當您修改了系統設定後，執行備份腳本即可同步：

```bash
~/dotfiles/scripts/backup.sh
cd ~/dotfiles
git add .
git commit -m "Update settings"
git push
```

---
*Created by Gemini CLI Agent for Benny Tsai*
