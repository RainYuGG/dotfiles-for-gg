local wk = require("which-key")

wk.add({
  -----------------------------------------------------------------------------
  -- 1. 一般模式 (Normal Mode) 快捷鍵
  -----------------------------------------------------------------------------
  {
    mode = "n", -- 指定以下皆為一般模式

    -- 【LSP 群組】
    { "<leader>l", group = "LSP" },
    { "<leader>lh", "<cmd>lua vim.lsp.buf.hover()<cr>", desc = "Hover Documentation" },
    { "<leader>ld", "<cmd>lua vim.lsp.buf.definition()<cr>", desc = "Definition" },
    { "<leader>lc", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
    { "<leader>lf", "<cmd>lua vim.lsp.buf.format({ async = true })<cr>", desc = "Formater" },

    -- 【Claude AI 助理群組】（已同步更新為你習慣的名稱與敘述）
    { "<leader>c", group = "Claude AI" },
    { "<leader>cc", "<cmd>ClaudeCode<cr>", desc = "Claude Code (New Session)", silent = true },
    { "<leader>cr", "<cmd>ClaudeCode --resume<cr>", desc = "Claude Code (Resume CCR)", silent = true },

    -- 【Telescope / 尋找群組】
    { "<leader>f", group = "Find / Telescope" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    { "<leader>fb", "<cmd>Telescope file_browser<cr>", desc = "File Browser" },
    { "<leader>ft", "<cmd>Telescope buffers<cr>", desc = "Opened Buffers" },
    {
      "<leader>fg",
      "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
      desc = "Live Grep (Args)",
    },

    -- 【Bufferline / 頁籤管理群組】
    { "<leader>b", group = "Buffer" },
    { "<leader>bb", "<cmd>BufferLinePick<cr>", desc = "Pick Buffer" },
    { "<leader>bd", "<cmd>bd<cr>", desc = "Delete Buffer" },

    -- 【Go / 導航群組】
    { "<leader>g", group = "Go / Goto" },
    { "<leader>gn", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer" },
    { "<leader>gp", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Buffer" },

    -- 【快速跳轉特定頁籤 (1~9)】
    { "<leader>1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Go to Buffer 1" },
    { "<leader>2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Go to Buffer 2" },
    { "<leader>3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Go to Buffer 3" },
    { "<leader>4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Go to Buffer 4" },
    { "<leader>5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Go to Buffer 5" },
    { "<leader>6", "<cmd>BufferLineGoToBuffer 6<cr>", desc = "Go to Buffer 6" },
    { "<leader>7", "<cmd>BufferLineGoToBuffer 7<cr>", desc = "Go to Buffer 7" },
    { "<leader>8", "<cmd>BufferLineGoToBuffer 8<cr>", desc = "Go to Buffer 8" },
    { "<leader>9", "<cmd>BufferLineGoToBuffer 9<cr>", desc = "Go to Buffer 9" },

    -- 【Theme & Highlight / 視覺群組】
    { "<leader>t", group = "Theme" },
    { "<leader>th", "<cmd>Telescope colorscheme<cr>", desc = "Select Colorscheme" },
    { "<leader>h", group = "Highlight" },
    { "<leader>hi", "<cmd>TSToggle highlight<cr>", desc = "Toggle Treesitter Highlight" },

    -- 【Session 群組】
    { "<leader>s", group = "Session" },
    { "<leader>sl", "<cmd>SessionLoad<cr>", desc = "Load Recent Session" },

    -- 【全域縮排與獨立鍵】
    { "<leader>i", "gg=G", desc = "Auto Indent File", silent = true },
    { "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Buffer (Ctrl-Tab)" },

    -- 【功能鍵區塊】（獨立按鍵）
    { "<F2>", "<cmd>Neotree toggle<cr>", desc = "Toggle NeoTree File Tree" },
    { "<F3>", "<cmd>Neotree git_status toggle<cr>", desc = "Toggle NeoTree Git Status" },
    { "<F4>", "<cmd>Neotree buffers toggle<cr>", desc = "Toggle NeoTree Buffers" },
    { "<F5>", "<cmd>Neotree document_symbols toggle<cr>", desc = "Toggle NeoTree Symbols" },
    { "<F10>", "<cmd>TagbarToggle<cr>", desc = "Toggle Tagbar Outline" },
  },

  -----------------------------------------------------------------------------
  -- 2. 插入模式 (Insert Mode) 快捷鍵
  -----------------------------------------------------------------------------
  {
    mode = "i", -- 指定以下皆為插入模式

    -- 改用 Alt 系列，完全不與 Tmux Prefix 衝突
    { "<M-a>", "<ESC>I", desc = "Move to Line Start", silent = true },
    { "<M-e>", "<ESC>A", desc = "Move to Line End", silent = true },
  },

  -- 讓 macOS 的 Command+v 在插入模式下完美貼上，不觸發自動縮排
  vim.keymap.set("i", "<D-v>", "<C-r>+", { noremap = true, silent = true }),
})
