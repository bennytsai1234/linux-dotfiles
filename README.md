# 🚀 Linux God Mode Dotfiles (系統自動化備份與還原)

這是專為 Linux (Ubuntu/Debian) 開發者設計的 **全自動環境管理系統**。它不只是備份 Dotfiles，更能深度還原系統軟體、VS Code 配置、GNOME 桌面設定以及開發環境。

---

## ⚡ 快速開始 (如何在「新電腦」上還原)

當你拿到一台剛重灌好的 Linux 電腦，只需執行以下步驟，即可恢復 95% 的工作環境。

### 1. 安裝基礎工具
新電腦通常需要 Git 與 Stow，請先打開終端機執行：
```bash
sudo apt update && sudo apt install -y git stow
```

### 2. 下載備份
將倉庫複製到你的使用者目錄：
```bash
git clone https://github.com/bennytsai1234/linux-dotfiles.git $HOME/dotfiles
```

### 3. 一鍵還原 (God Mode)
進入目錄並執行還原腳本：
```bash
cd $HOME/dotfiles
chmod +x install.sh
./install.sh
```
**注意：** 腳本執行過程中會詢問是否安裝軟體清單以及覆蓋桌面設定，請根據需求輸入 `y`。

---

## 🔄 日常維護 (如何更新備份)

當你安裝了新軟體、修改了 Zsh 設定或 VS Code 配置，想要更新備份時：

### 1. 執行備份腳本
```bash
~/dotfiles/scripts/backup.sh
```
此腳本會自動掃描 APT/Snap 軟體、匯出 VS Code 外掛清單、更新 GNOME 桌面設定。

### 2. 上傳到 GitHub
```bash
cd ~/dotfiles
git add .
git commit -m "Update settings: $(date +'%Y-%m-%d')"
git push
```

---

## 🛠️ 系統功能清單

| 功能 | 說明 |
| --- | --- |
| **軟體清單管理** | 自動備份並安裝 APT (360+) 與 Snap 軟體清單 |
| **自動符號連結** | 使用 GNU Stow 自動管理 `.zshrc`, `.gitconfig`, `.profile` 等 |
| **VS Code 全同步** | 自動還原 `settings.json`、快捷鍵以及所有擴充套件 |
| **桌面環境優化** | 備份並還原 GNOME (Dconf) 設定（含佈景主題、捷徑、系統行為） |
| **終端機美化** | 完美整合 Zsh 與 Powerlevel10k 配置 |
| **模組化設計** | 檔案按功能分類 (git, zsh, vscode, system)，易於維護 |

---

## ⚠️ 手動還原項目 (重要！)
由於安全與技術限制，以下項目需 **手動處理**：

1. **SSH 金鑰 (.ssh)**
   - 基於安全理由，私鑰未被備份。請手動從安全路徑還原。
2. **GPG 金鑰**
   - 若有加密需求，請手動匯入您的 GPG Key。
3. **瀏覽器登入狀態**
   - 所有的 Session 與 Cookies 需手動重新登入。

---
*Created by Gemini CLI Agent*