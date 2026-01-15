# 🚀 Linux God Mode Dotfiles (WSL2 Pure Terminal Edition)

這是專為 **Windows Subsystem for Linux (WSL2 - Ubuntu 24.04+)** 開發者設計的 **極簡、純文字 (CLI-Only) 開發環境**。

我們移除了所有的圖形介面 (GUI)、Snap 套件、遊戲驅動與肥大軟體，只保留最高效的開發工具。這套配置保證了極致的啟動速度與最小的磁碟佔用。

## ✨ 特色 (Pure Terminal)

- **🚫 零 GUI 依賴**：完全移除 X11, GNOME, Qt, GTK 等圖形庫。
- **🚫 零 Snap**：僅使用 APT 與原生二進位檔，避免 Snap 的效能損耗與空間浪費。
- **🪟 WSL2 深度整合**：
    - 內建 `open .` 指令，直接呼叫 Windows 檔案總管開啟當前目錄。
    - 預設啟用圖示支援 (搭配 Windows Terminal + Nerd Font)。
- **⚡ 極速開發工具**：
    - **Shell**: Zsh + Powerlevel10k + Auto Suggestions。
    - **Modern CLI**: `lsd` (取代 ls), `batcat` (取代 cat), `btop` (取代 top), `ripgrep`, `fd-find`。
    - **Dev Stack**: GCC/G++, CMake, Python3, Node.js, OpenJDK 17。
- **🇹🇼 台灣在地化**：自動切換至 `tw.archive.ubuntu.com` 加速下載。

---
 以下是重灌 WSL2 並使用您的 dotfiles 還原環境的步驟：

  第一步：在 Windows 側重灌 WSL2 (PowerShell)

  請在 Windows 打開 PowerShell (以管理員身分)，執行以下指令：

   1. 查看目前的 Distro 名稱：
        wsl -l -v
      (假設您的名稱是 `Ubuntu`)

   2. 註銷 (刪除) 現有的系統：
        wsl --unregister Ubuntu

   3. 重新安裝：
        wsl --install -d Ubuntu
      安裝完成後，設定好您的使用者名稱 (benny) 和密碼。

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

### 3. 一鍵還原
```bash
cd $HOME/dotfiles
chmod +x install.sh
./install.sh
```
**腳本將自動執行：**
1. 設定 Sudo 免密碼與台灣軟體源。
2. 安裝 Oh My Zsh 與 Powerlevel10k 主題。
3. 連結設定檔 (Zsh, Git, VS Code, Gemini)。
4. 安裝精簡版開發軟體。

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
├── install.sh          # 核心還原腳本 (Pure CLI)
├── packages/
│   └── apt-list.txt    # 精簡後的軟體清單 (無 Snap/GUI)
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
