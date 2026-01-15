# 🚀 Linux God Mode Dotfiles (WSL2 Developer Edition)

這是專為 **Windows Subsystem for Linux (WSL2 - Ubuntu 24.04+)** 開發者設計的 **全自動環境管理系統**。特別針對 **AGV/機器人開發** 進行了深度優化，移除了所有遊戲與硬體驅動冗餘，保留最純粹的高效開發環境。

## ✨ 特色

- **🪟 WSL2 深度整合**：
    - 自動偵測環境，跳過不相容的桌面設定 (GNOME) 還原。
    - 內建 `open .` 指令，直接呼叫 Windows 檔案總管開啟當前目錄。
    - 預設啟用圖示支援 (搭配 Windows Terminal + Nerd Font)。
- **⚡ 極速開發環境**：
    - **純淨化**：移除 32 位元架構、遊戲驅動 (Lutris/Nvidia) 與肥大軟體 (LibreOffice)，節省數 GB 空間。
    - **自動化**：一鍵安裝 Zsh, Powerlevel10k, Node.js, Python, C++ Build Tools。
- **🇹🇼 台灣在地化**：自動切換至 `tw.archive.ubuntu.com` 加速下載。
- **🤖 Gemini 整合**：內建 C++ (AGV/Robotics) 面試衝刺學習清單。

---

## ⚡ 快速開始 (如何在 WSL2 上還原)

當你安裝好新的 Ubuntu (WSL2)，只需執行以下步驟：

### 1. 安裝基礎工具
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
**腳本將自動執行：**
1. 設定 Sudo 免密碼與台灣軟體源。
2. 安裝 Oh My Zsh 與 Powerlevel10k 主題。
3. 連結設定檔 (Zsh, Git, VS Code, Gemini)。
4. 安裝精簡版開發軟體 (Git, CMake, Node.js, Python, Rippergrep, FZF...)。
5. (WSL 模式) 自動跳過桌面環境還原，避免錯誤。

---

## ⌨️ 常用指令與別名 (Aliases)

| 指令 | 說明 | 對應原指令 |
| --- | --- | --- |
| `open .` | **[WSL獨家]** 用 Windows 檔案總管開啟目錄 | `explorer.exe .` |
| `update` | 系統全面更新 | `sudo apt update && upgrade...` |
| `install <pkg>` | 安裝軟體 | `sudo apt install -y <pkg>` |
| `p` | 切換到 AGV 專案 | `cd ~/agv_project` |
| `d` | 切換到 Dotfiles | `cd ~/dotfiles` |
| `st` / `gs` | Git Status | `git status` |
| `lg` | Git Log (圖形化) | `git log --graph...` |
| `ls` | 列出檔案 (圖示版) | `lsd` |
| `cat` | 查看檔案 (高亮版) | `batcat` |

---

## 📂 目錄結構

```
dotfiles/
├── install.sh          # 核心還原腳本 (含 WSL 偵測)
├── packages/           # 精簡後的軟體清單 (無 Bloatware)
├── vscode/             # VS Code 全端開發擴充 (C++, Python, Web)
├── zsh/                # .zshrc (含 WSL 整合)
├── git/                # .gitconfig (含中文路徑修正)
├── scripts/            # 自動化備份腳本
└── gemini/             # 面試準備資料
```

## 🔄 如何更新備份

```bash
~/dotfiles/scripts/backup.sh
cd ~/dotfiles
git add .
git commit -m "Update settings"
git push
```

---
*Created by Gemini CLI Agent for Benny Tsai*
