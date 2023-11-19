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

-- Keybindings for NERDTree
map("n", "<F2>", "<CMD>NvimTreeToggle<CR>")

-- Keybindings for tagbar
map("n", "<F3>", "<CMD>TagbarToggle<CR>")

-- Keybindings for TSToggle highlighting
map("n", "<leader>hi", "<CMD>TSToggle highlight<CR>")

