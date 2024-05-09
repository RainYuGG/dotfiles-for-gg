local g = vim.g
local o = vim.o
local opt = vim.opt

-- cmd('syntax on')
-- vim.api.nvim_command('filetype plugin indent on')

-- o.termguicolors = true
-- o.background = 'dark'

-- Do not save when switching buffers
-- o.hidden = true

-- Decrease update time
o.timeoutlen = 500
o.updatetime = 200

-- Number of screen lines to keep above and below the cursor
o.scrolloff = 8

-- Better editor UI
o.number = true
o.numberwidth = 2
o.relativenumber = true
o.signcolumn = "yes"
o.cursorline = true

-- Better editing experience
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

-- o.listchars = 'eol:¬,space:·,lead: ,trail:·,nbsp:◇,tab:→-,extends:▸,precedes:◂,multispace:···⬝,leadmultispace:│   ,'
-- o.formatoptions = 'qrn1'

-- Makes neovim and host OS clipboard play nicely with each other
o.clipboard = "unnamedplus"

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.smartcase = true

-- Undo and backup options
o.backup = false
o.writebackup = false
o.undofile = true
o.swapfile = false
-- o.backupdir = '/tmp/'
-- o.directory = '/tmp/'
-- o.undodir = '/tmp/'

-- Remember 50 items in commandline history
o.history = 50

-- Better buffer splitting
o.splitright = true
o.splitbelow = true

-- Preserve view while jumping
-- BUG This option causes an error!
-- o.jumpoptions = 'view'

-- BUG: this won't update the search count after pressing `n` or `N`
-- When running macros and regexes on a large file, lazy redraw tells neovim/vim not to draw the screen
-- o.lazyredraw = true

-- Better folds (don't fold by default)
-- o.foldmethod = 'indent'
-- o.foldlevelstart = 99
-- o.foldnestmax = 3
-- o.foldminlines = 1

-- opt.encoding=utf-8
-- opt.laststatus=2
-- -- Show (partial) command in status line.
-- opt.showcmd	= true	    
-- -- Show matching brackets.
-- opt.showmatch = true 		
-- -- Do case insensitive matching
-- opt.ignorecase = true		
-- -- Do smart case matching
-- opt.smartcase = true	
-- -- highlight for search 
-- opt.hlsearch        
-- -- Incremental search
-- opt.incsearch		
-- -- Automatically save before commands like :next and :make
-- -- opt.autowrite	
-- -- Hide buffers when they are abandoned
-- -- opt.hidden	

-- Map <leader> to space
g.mapleader = " "
g.maplocalleader = " "

 -- Enable mouse usage (all modes)
opt.mouse = "a"

g.tagbar_width=35
g.tagbar_autofocus=1
g.tagbar_left = 0

-- nvim-tree examples for your init.lua
-- disable netrw at the very start of your init.lua (strongly advised)
g.loaded_netrw = 1
g.loaded_netrwPlugin = 1

o.background ='dark'
-- set termguicolors to enable highlight groups
if vim.env.TERM_PROGRAM == "Apple_Terminal" then
    o.t_Co = 256
    -- gruvbox setting
    vim.cmd([[colorscheme gruvbox]])
    -- autocmd("vimenter", {
	--     nested = true,
	--     callback = function()
	-- 	vim.cmd([[colorscheme gruvbox]])
	--     end
    -- })
else 
    vim.opt.termguicolors = true
end
