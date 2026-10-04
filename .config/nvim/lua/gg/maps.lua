-- Centralized Keymaps registered with which-key v3 (`wk.add`)
-- All editor mappings are unified here. Do not duplicate in lazy specs or lsp configs.
local ok, wk = pcall(require, "which-key")
if not ok then
	vim.notify("which-key not found, keymaps not registered", vim.log.levels.WARN)
	return
end

wk.add({
	-- Insert mode: mimic shell movements
	{ "<C-E>", "<ESC>A", desc = "Go to end of line", mode = "i" },
	{ "<C-A>", "<ESC>I", desc = "Go to start of line", mode = "i" },

	-- Window & Tmux navigation (vim-tmux-navigator)
	{ "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Window / tmux left" },
	{ "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Window / tmux down" },
	{ "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Window / tmux up" },
	{ "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Window / tmux right" },
	{ "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Window / tmux previous" },

	-- Telescope: Find (<leader>f)
	{ "<leader>f", group = "find" },
	{ "<leader>ff", "<CMD>Telescope find_files<CR>", desc = "Find files" },
	{ "<leader>fr", "<CMD>Telescope oldfiles<CR>", desc = "Recent files" },
	{ "<leader>fb", "<CMD>Telescope file_browser<CR>", desc = "File browser" },
	{ "<leader>fg", function() require("telescope").extensions.live_grep_args.live_grep_args() end, desc = "Live grep (args)" },
	{ "<leader>fw", "<CMD>Telescope live_grep<CR>", desc = "Live grep (word)" },
	{ "<leader>ft", "<CMD>Telescope buffers<CR>", desc = "Buffers" },

	-- Theme (<leader>t)
	{ "<leader>t", group = "theme" },
	{ "<leader>th", "<CMD>Telescope colorscheme<CR>", desc = "Colorscheme" },

	-- Neo-tree (Function keys)
	{ "<F2>", "<CMD>Neotree toggle<CR>", desc = "Neotree toggle" },
	{ "<F3>", "<CMD>Neotree float git_status toggle<CR>", desc = "Neotree git status" },
	{ "<F4>", "<CMD>Neotree buffers toggle<CR>", desc = "Neotree buffers" },
	{ "<F5>", "<CMD>Neotree document_symbols toggle<CR>", desc = "Neotree symbols" },

	-- Buffers (<leader>b)
	{ "<leader>b", group = "buffer" },
	{ "<leader>bb", "<CMD>BufferLinePick<CR>", desc = "Pick buffer" },
	{ "<leader>bd", "<CMD>bdelete<CR>", desc = "Delete buffer" },
	{ "<C-Tab>", "<CMD>BufferLineCycleNext<CR>", desc = "Next buffer" },
	{ "<leader>gn", "<CMD>BufferLineCycleNext<CR>", desc = "Next buffer" },
	{ "<leader>gp", "<CMD>BufferLineCyclePrev<CR>", desc = "Previous buffer" },
	{ "<leader>1", "<CMD>BufferLineGoToBuffer 1<CR>", desc = "Buffer 1" },
	{ "<leader>2", "<CMD>BufferLineGoToBuffer 2<CR>", desc = "Buffer 2" },
	{ "<leader>3", "<CMD>BufferLineGoToBuffer 3<CR>", desc = "Buffer 3" },
	{ "<leader>4", "<CMD>BufferLineGoToBuffer 4<CR>", desc = "Buffer 4" },
	{ "<leader>5", "<CMD>BufferLineGoToBuffer 5<CR>", desc = "Buffer 5" },
	{ "<leader>6", "<CMD>BufferLineGoToBuffer 6<CR>", desc = "Buffer 6" },
	{ "<leader>7", "<CMD>BufferLineGoToBuffer 7<CR>", desc = "Buffer 7" },
	{ "<leader>8", "<CMD>BufferLineGoToBuffer 8<CR>", desc = "Buffer 8" },
	{ "<leader>9", "<CMD>BufferLineGoToBuffer 9<CR>", desc = "Buffer 9" },

	-- Code & LSP (<leader>c)
	{ "<leader>c", group = "code", mode = { "n", "v" } },
	{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" } },
	{ "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format buffer / selection", mode = { "n", "v" } },
	{ "<leader>rn", vim.lsp.buf.rename, desc = "Rename symbol" },
	{ "<leader>cs", "<CMD>Trouble symbols toggle focus=false<CR>", desc = "Symbols outline (Trouble)" },

	-- LSP Navigation
	{ "K", vim.lsp.buf.hover, desc = "Hover documentation" },
	{ "gd", vim.lsp.buf.definition, desc = "Goto definition" },
	{ "df", vim.lsp.buf.definition, desc = "Goto definition" },
	{ "gD", vim.lsp.buf.declaration, desc = "Goto declaration" },
	{ "gi", vim.lsp.buf.implementation, desc = "Goto implementation" },
	{ "gr", vim.lsp.buf.references, desc = "Goto references" },

	-- Diagnostics (<leader>d, [d, ]d)
	{ "<leader>d", vim.diagnostic.open_float, desc = "Line diagnostic" },
	{ "<leader>q", vim.diagnostic.setloclist, desc = "Diagnostic list" },
	{ "[d", vim.diagnostic.goto_prev, desc = "Previous diagnostic" },
	{ "]d", vim.diagnostic.goto_next, desc = "Next diagnostic" },

	-- Trouble (<leader>x)
	{ "<leader>x", group = "trouble" },
	{ "<leader>xx", "<CMD>Trouble diagnostics toggle<CR>", desc = "Diagnostics (Trouble)" },
	{ "<leader>xX", "<CMD>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Buffer diagnostics (Trouble)" },

	-- Search & Todo (<leader>s, [t, ]t)
	{ "<leader>s", group = "search" },
	{ "<leader>st", "<CMD>TodoTelescope<CR>", desc = "Search TODO comments" },
	{ "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
	{ "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
}, { silent = true })
