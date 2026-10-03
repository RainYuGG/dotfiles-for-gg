# dotfiles-for-gg

個人現代化跨平台終端開發環境設定，支援 **Ubuntu (Linux)** 與 **macOS (Darwin)**。

整合 **Zsh**、**Powerlevel10k**、**Tmux**、**Neovim**、**Git Delta**、**fzf** 與 **Kubernetes** 工具鏈，透過單一腳本自動化完成所有套件安裝、符號連結（Symlink）與環境設定。

---

## 核心功能與特色

* **Shell 環境**：
  * 使用 **Zsh** + **Oh My Zsh**，搭配 **Powerlevel10k** 終端主題與 Instant Prompt 極速啟動。
  * 採用 **fzf** 官方標準整合（`source <(fzf --zsh)>`），提供模糊搜尋、歷史紀錄搜尋與補全。
  * 針對 **Ubuntu** 與 **macOS** 自動適配相應指令（如 `batcat`/`bat`、`fdfind`/`fd`、`xclip`/`pbcopy`）。
* **終端多工**：
  * **Tmux** 預設設定，整合 **TPM (Tmux Plugin Manager)** 進行外掛管理與自動安裝。
* **程式編輯**：
  * **Neovim** 完整開發環境，透過 **Lazy.nvim** 進行外掛管理，涵蓋 LSP、Telescope、Treesitter 等。
* **Git 增強**：
  * 整合 **Git Delta** 語法高亮分頁器，支援雙欄對比（Side-by-side）與列內編輯推論。
  * 內建 GitHub CLI (**gh**) 自動配置與常用的 Git 快捷別名。
* **Kubernetes 輔助**：
  * 自動生成 **Kubectl** Zsh 自動補全腳本。
  * 提供基於 **fzf** 的 Pod 快速選擇、互動連線與複製函式。

---

## 系統需求

* **Ubuntu**：Ubuntu 22.04 LTS 或更新版本（具備 `sudo` 權限）。
* **macOS**：macOS（推薦 Apple Silicon），需預先安裝 [Homebrew](https://brew.sh)。

---

## 快速安裝

請先將此倉庫複製至使用者家目錄，並執行初始化腳本：

```bash
# 1. 複製倉庫
git clone https://github.com/your-username/dotfiles-for-gg.git ~/dotfiles-for-gg
cd ~/dotfiles-for-gg

# 2. 執行安裝腳本
./init.sh

# 3. 重新載入 Shell
exec zsh
```

---

## 安裝流程與跨平台架構

`init.sh` 採循序漸進（Sequential）的線性設計，無多餘抽象封裝，分為 8 個清晰階段執行：

| 步驟 | 項目 | Ubuntu (Linux) 處理方式 | macOS (Darwin) 處理方式 |
| :--- | :--- | :--- | :--- |
| **[1/8]** | **平台偵測** | 識別為 `ubuntu` | 識別為 `macos` |
| **[2/8]** | **建立軟連結** | 建立 `~/.tmux.conf`、`~/.zshrc`、`~/.config/nvim` 符號連結 | 同左 |
| **[3/8]** | **基礎套件安裝** | 透過 **APT** 一次安裝系統基礎工具（`zsh`, `tmux`, `bat`, `ripgrep`, `fd-find`, `zoxide` 等） | 透過 **Homebrew** 一次安裝所有命令列與開發套件（含 `neovim`, `helm`, `node@22` 等） |
| **[4/8]** | **Node.js 與開發工具** | 設定 **NodeSource 22** 倉庫安裝 `nodejs`；透過 **Snap** 安裝 `nvim`, `helm`, `kubectl`, `go` | 先前已由 Homebrew 裝妥，直接略過 |
| **[5/8]** | **Git Delta** | 依官方指示自 GitHub Releases 下載對應架構之 `.deb` 檔，以 `dpkg -i` 安裝 | 先前已由 Homebrew 裝妥，直接略過 |
| **[6/8]** | **fzf** | Git Clone 至 `~/.fzf` 並執行官方 `./install` 安裝最新二進位檔 | 先前已由 Homebrew 裝妥，直接略過 |
| **[7/8]** | **終端擴充套件** | 自動 Clone 並更新 **Oh My Zsh**、**Powerlevel10k**、**TPM**，觸發外掛安裝 | 同左 |
| **[8/8]** | **工具設定與插件** | 配置 **Git**、**GitHub CLI**、**Kubectl** 補全檔，觸發 **Neovim** Lazy 外掛更新 | 同左 |

---

## 常用命令與別名

### Git 常用操作
* `gco`：透過 **fzf** 互動式選單檢視最近分支並快速切換。
* `glog`：美化樹狀單行 Commit 歷史圖。
* `gpfwl`：安全強制推送（`git push --force-with-lease origin HEAD`）。
* `gpsu`：推送並追蹤上游（`git push --set-upstream origin HEAD`）。
* `diff`：以 **Git Delta** 檢視差異。

### Kubernetes 常用操作
* `k`：`kubectl` 縮寫。
* `kgp`：透過 **fzf** 模糊搜尋並選取 Pod 名稱。
* `kpod`：透過選單直接連線進入 Pod 的 Bash 終端。
* `kcp <file>`：互動選取目標 Pod 並將檔案複製至該 Pod 的 `/tmp/` 目錄。

### 系統與通用工具
* `vim` / `vimdiff`：導向至 `nvim` / `nvim -d`。
* `bat` / `cat`：以語法高亮分頁器替代。
* `fd`：快速檔案搜尋（自動映射 `fd` 或 `fdfind`）。
* `open`：依平台開啟檔案或 URL（Ubuntu 為 `xdg-open`，macOS 為 `open`）。
* `c` / `p`：系統剪貼簿複製（支援管線輸入）與貼上。
* `so`：重新載入 `~/.zshrc` 並更新執行中的 Tmux 設定。
* `re`：重啟目前 Shell（`exec $SHELL`）。

---

## 專案目錄結構

```text
dotfiles-for-gg/
├── .config/
│   └── nvim/           # Neovim 配置與插件定義
├── .tmux.conf          # Tmux 設定檔
├── .zshrc              # Zsh 主要設定檔
├── init.sh             # 跨平台一鍵安裝腳本
├── docker-update/      # Docker 工具環境構建檔
└── README.md           # 專案文件
```
