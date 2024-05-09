local function map(m, k, v)
	vim.keymap.set(m, k, v, { silent = true })
end

-- indent
-- map("n", "<leader>i", "gg=G", opt)

-- Mimic shell movements
map("i", "<C-E>", "<ESC>A")
map("i", "<C-A>", "<ESC>I")

-- Load recent sessions
-- map("n", "<leader>sl", "<CMD>SessionLoad<CR>")

-- Keybindings for telescope
map("n", "<leader>fr", "<CMD>Telescope oldfiles<CR>")
map("n", "<leader>ff", "<CMD>Telescope find_files<CR>")
map("n", "<leader>fb", "<CMD>Telescope file_browser<CR>")
-- map("n", "<leader>fg", "<CMD>Telescope live_grep<CR>")
map("n", "<leader>fg", "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>")
map("n", "<leader>th", "<CMD>Telescope colorscheme<CR>")
map("n", "<leader>ft", "<CMD>Telescope buffers<CR>")

-- Keybindings for NeoTree
map("n", "<F2>", "<CMD>Neotree toggle<CR>")
map("n", "<F3>", "<CMD>Neotree float git_status toggle <CR>")
map("n", "<F4>", "<CMD>Neotree buffers toggle <CR>")
map("n", "<F5>", "<CMD>Neotree document_symbols toggle<CR>")

-- Keybindings for tagbar
map("n", "<F10>", "<CMD>TagbarToggle<CR>")

-- Keybindings for TSToggle highlighting
map("n", "<leader>hi", "<CMD>TSToggle highlight<CR>")

-- Keybindings for bufferline
map("n", "<leader>bb", "<CMD>BufferLinePick<CR>")
map("n", "<leader>bd", "<CMD>bd<CR>")
map("n", "C-Tab", "<CMD>BufferLineCycleNext<CR>")
map("n", "<leader>gn", "<CMD>BufferLineCycleNext<CR>")
map("n", "<leader>gp", "<CMD>BufferLineCyclePrev<CR>")
map("n", "<leader>1", "<CMD>BufferLineGoToBuffer 1<CR>")
map("n", "<leader>2", "<CMD>BufferLineGoToBuffer 2<CR>")
map("n", "<leader>3", "<CMD>BufferLineGoToBuffer 3<CR>")
map("n", "<leader>4", "<CMD>BufferLineGoToBuffer 4<CR>")
map("n", "<leader>5", "<CMD>BufferLineGoToBuffer 5<CR>")
map("n", "<leader>6", "<CMD>BufferLineGoToBuffer 6<CR>")
map("n", "<leader>7", "<CMD>BufferLineGoToBuffer 7<CR>")
map("n", "<leader>8", "<CMD>BufferLineGoToBuffer 8<CR>")
map("n", "<leader>9", "<CMD>BufferLineGoToBuffer 9<CR>")

-- Keybindings for lsp
map('n', 'K', vim.lsp.buf.hover)
map('n', 'df', vim.lsp.buf.definition)
map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action)
