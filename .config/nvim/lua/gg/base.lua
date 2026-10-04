local g = vim.g
local o = vim.o
local opt = vim.opt

-- Disable unused remote providers for faster startup and clean checkhealth
g.loaded_node_provider = 0
g.loaded_python3_provider = 0
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

-- Map <leader> to space (must be set before loading plugins)
g.mapleader = " "
g.maplocalleader = " "

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Screen and UI
o.scrolloff = 8
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true
o.termguicolors = true
o.background = "dark"

-- Modern Neovim enhancements
o.confirm = true       -- Prompt to save before exiting unsaved buffer
o.inccommand = "split" -- Live preview of search/replace in a split window
if vim.fn.has("nvim-0.10") == 1 then
    o.smoothscroll = true -- Smooth scrolling for <C-u> / <C-d>
end

-- Indentation and Tabs
o.expandtab = true
o.smarttab = true
o.cindent = true
o.autoindent = true
o.wrap = true
o.textwidth = 300
o.tabstop = 4
o.shiftwidth = 4
o.softtabstop = -1 -- If negative, shiftwidth value is used
o.list = true
o.listchars = "trail:·,nbsp:◇,tab:→ ,extends:▸,precedes:◂"

-- Clipboard: plays nicely with OS clipboard
o.clipboard = "unnamedplus"

-- Search options
o.ignorecase = true
o.smartcase = true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false

-- Commandline history
o.history = 50

-- Buffer splitting
o.splitright = true
o.splitbelow = true

-- Mouse usage
opt.mouse = "a"


-- Disable netrw for tree file managers
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

