-- Define autocommands with Lua APIs
-- See: h:api-autocmd, h:augroup

local augroup = vim.api.nvim_create_augroup   -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd   -- Create autocommand

-- Uncomment just ONE of the following colorschemes!
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-dracula')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-gruvbox-dark-medium')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-monokai')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-nord')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-oceanicnext')
-- local ok, _ = pcall(vim.cmd, "colorscheme base16-onedark")
-- local ok, _ = pcall(vim.cmd, 'colorscheme palenight')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-solarized-dark')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-solarized-light')
-- local ok, _ = pcall(vim.cmd, 'colorscheme base16-tomorrow-night')

-- Highlight the region on yank
-- autocmd("TextYankPost", {
-- 	group = num_au,
-- 	callback = function()
-- 		vim.highlight.on_yank({ higroup = "Visual", timeout = 120 })
-- 	end,
-- })

-- Load the colorscheme

-- gruvbox-baby config & setting
local colors = require("gruvbox-baby.colors").config()
vim.g.gruvbox_baby_highlights = {Normal = {fg = colors.foreground}}
-- Enable telescope theme
vim.g.gruvbox_baby_telescope_theme = 1
-- Enable transparent mode
vim.g.gruvbox_baby_transparent_mode = 1