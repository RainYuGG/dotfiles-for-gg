# dotfiles

個人現代化跨平台終端開發環境設定，支援 **Ubuntu (Linux)** 與 **macOS (Darwin)**。

整合 **Zsh**、**Powerlevel10k**、**Tmux**、**Neovim**、**Git Delta**、**fzf**、**OpenCode (AI Agent)**、**OS 安全憑證庫**、**Gitleaks 防護** 與 **Kubernetes** 工具鏈，透過單一腳本自動化完成所有套件安裝、符號連結（Symlink）與環境設定。

---

## 核心功能與特色

* **Shell 環境**：
  * 使用 **Zsh** + **Oh My Zsh**，搭配 **Powerlevel10k** 終端主題與 Instant Prompt 極速啟動。
  * 採用 **fzf** 官方標準整合（`source <(fzf --zsh)>`），提供模糊搜尋、歷史紀錄搜尋與補全。
  * 針對 **Ubuntu** 與 **macOS** 自動適配相應指令（如 `batcat`/`bat`、`fdfind`/`fd`、`xclip`/`pbcopy`）。
* **終端多工**：
  * **Tmux** 預設設定，整合 **TPM (Tmux Plugin Manager)** 進行外掛管理與自動安裝。
* **程式編輯**：
  * **Neovim** (0.11+) 現代化開發環境，採用 **Lazy.nvim** 外掛管理。
  * 整合 **Mason + LSP**、**nvim-cmp** 代碼補全、**Which-Key (v3)**、**Neo-tree** 與快速檔案切換。
* **AI 終端 Agent (OpenCode & OmO)**：
  * 內建 **OpenCode** (`opencode-ai`) 與 **Oh My OpenAgent** (`omo-ai`) npm 全域工具。
  * 核心設定檔脫敏保存於倉庫（`opencode.jsonc`），以環境變數佔位符取代寫死的憑證。
* **安全憑證與機密防護 (Secret Management & Leak Prevention)**：
  * **Git Clean Filter 自動脫敏**：本機可直接於 `.zshrc` 設定 `LOCAL_SERVER_API_KEY`，透過 `.gitattributes` 與 Git Clean Filter，在 commit 時自動過濾為空字串，Repo 永遠保持純淨。
  * **全域 Pre-Commit 攔截**：透過 Git 全域 `core.hooksPath` 自動設定 Hook，若暂存區內含未脫敏的 API Key 或敏感 Token，**直接阻止 Commit**。
  * **全域 Gitleaks 掃描**：整合 Gitleaks 即時掃描高熵憑證。
  * **全域忽略規則**：自動忽略 `.omo`、`.omp`、`*.local` 與 `.env*` 檔案。
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
git clone https://github.com/RainYuGG/dotfiles.git ~/dotfiles
cd ~/dotfiles

# 2. 執行安裝腳本（Ubuntu 僅需於開頭互動輸入一次 sudo 密碼，全程自動背景保活）
./init.sh

# 3. 重新載入 Shell
exec zsh
```

---

## 安裝流程與跨平台架構

`init.sh` 採循序漸進（Sequential）的線性設計，分為 8 個清晰階段執行：

| 步驟 | 項目 | Ubuntu (Linux) 處理方式 | macOS (Darwin) 處理方式 |
| :--- | :--- | :--- | :--- |
| **[1/8]** | **平台偵測** | 識別為 `ubuntu` | 識別為 `macos` |
| **[2/8]** | **建立軟連結** | 連結 `.tmux.conf`, `.zshrc`, `.config/nvim`, `.config/git/ignore`, `.config/git/hooks/pre-commit`, `.config/opencode` | 同左 |
| **[3/8]** | **基礎套件安裝** | 透過 **APT** 安裝系統基礎工具（`zsh`, `tmux`, `bat`, `ripgrep`, `fd-find`, `zoxide` 等） | 透過 **Homebrew** 安裝基礎工具、**`gitleaks`** 與 **`pre-commit`** |
| **[4/8]** | **開發語言與全域工具** | 安裝 Node.js 22、Bun，透過 npm 全域安裝 **`opencode-ai`** 與 **`omo-ai`**；Snap 安裝 `nvim`, `helm`, `kubectl`, `go` | 由 Homebrew 與 npm 管理全域工具 |
| **[5/8]** | **Git Delta & Gitleaks** | 自 GitHub Releases 下載對應架構之 `delta` (.deb) 與 **`gitleaks`** 二進位檔 | 先前已由 Homebrew 裝妥，直接略過 |
| **[6/8]** | **fzf** | Git Clone 至 `~/.fzf` 並執行官方 `./install` 安裝最新二進位檔 | 先前已由 Homebrew 裝妥，直接略過 |
| **[7/8]** | **終端擴充套件** | 自動 Clone 並更新 **Oh My Zsh**、**Powerlevel10k**、**TPM**，觸發外掛安裝 | 同左 |
| **[8/8]** | **工具設定與安全過濾** | ① 配置 Git 全域設定、`core.excludesfile` 與 **`core.hooksPath`**<br>② 設定 **`clean-secrets`** Git 過濾器（自動過濾 API Key） | 同左 |

---

## 安全憑證與機密防護機制

### 1. API Key 與 Git Clean Filter（自動脫敏）

為達到「本機設定方便、Repo 永遠乾淨、絕不意外 commit」，本設定採用 Git Clean Filter 內容過濾機制：

* **本機直接使用**：
  你在本機的 `.zshrc` 中可直接設定真實金鑰：
  ```bash
  export LOCAL_SERVER_API_KEY="<your-api-key>"
  ```
  OpenCode 啟動時即可無縫透過 `{env:LOCAL_SERVER_API_KEY}` 取得憑證。
* **Git 自動過濾（Clean Filter）**：
  透過 [.gitattributes](.gitattributes) 與 Git 的 `clean-secrets` 過濾器，任何時候 Git 執行暫存（`git add`）或提交（`git commit`）時，系統會自動將金鑰過濾為空字串：
  ```bash
  export LOCAL_SERVER_API_KEY=""
  ```
  因此 GitHub 或遠端倉庫永遠只會記錄空字串，即使執行 `git commit -a` 也絕不會提交真實金鑰。

### 2. Pre-Commit Hook 與 Gitleaks 雙重防護

* 全域 Git Hook 位於 `~/.config/git/hooks/pre-commit`。
* **第一道防線（專屬欄位檢查）**：若暫存區中的 `.zshrc` 包含非空字串之 `LOCAL_SERVER_API_KEY`，Hook 會直接拒絕 Commit。
* **第二道防線（Gitleaks 深度掃描）**：自動掃描所有 staged 檔案，若含有 API Key、私密 Token 或高熵字串，即刻終止 Commit。

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
dotfiles/
├── .config/
│   ├── git/
│   │   ├── hooks/
│   │   │   └── pre-commit    # 全域 Gitleaks 機密檢查 Hook
│   │   └── ignore            # 全域 Git 忽略規則 (.omo, *.local, .env* 等)
│   ├── nvim/                 # Neovim (Lazy.nvim, LSP, Treesitter, etc.)
│   └── opencode/             # OpenCode 核心設定 (opencode.jsonc)
├── .tmux.conf                # Tmux 設定檔
├── .zshrc                    # Zsh 主要設定檔（整合 clean-filter 自動脫敏）
├── .gitattributes            # Git 屬性設定（綁定 clean-secrets 過濾器）
├── .gitignore                # 倉庫本體忽略設定
├── init.sh                   # 跨平台一鍵安裝與部署腳本
├── docker-update/            # Docker 工具環境構建檔
└── README.md                 # 專案說明文件
```
