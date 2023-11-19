local status, packer = pcall(require, "packer")
if not status then
	print("Packer is not installed")
	return
end

-- Reloads Neovim after whenever you save plugins.lua
vim.cmd([[
    augroup packer_user_config
      autocmd!
     autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup END
]])

packer.startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")

	-- Gruvbox Colorscheme
	use("morhetz/gruvbox") 
	use("luisiacc/gruvbox-baby")

	-- Dashboard is a nice start screen for nvim
	use("glepnir/dashboard-nvim")
	-- use("goolord/alpha-nvim")


    -- Telescope
	use({"nvim-telescope/telescope.nvim",
		tag = "0.1.0",
		requires = { 
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-live-grep-args.nvim"},
	        ("nvim-telescope/telescope-file-browser.nvim"),
        },
        config = function()
            require("telescope").load_extension("live_grep_args")
        end
	})

	use("github/copilot.vim")


	use("nvim-treesitter/nvim-treesitter") -- Treesitter Syntax Highlighting
	
	-- -- Productivity
	-- use("vimwiki/vimwiki")
	-- use("jreybert/vimagit")
	-- use("nvim-orgmode/orgmode")

	-- use("folke/which-key.nvim") -- Which Key
	-- use("nvim-lualine/lualine.nvim") -- A better statusline

	-- -- File management --
	-- use("vifm/vifm.vim")
	-- use("scrooloose/nerdtree")	--nerdtree
	use("nvim-tree/nvim-tree.lua")	--nvim-tree
	-- use("tiagofumo/vim-nerdtree-syntax-highlight")
	use("majutsushi/tagbar")	--tagbar
	-- use("ryanoasis/vim-devicons")

	-- -- Tim Pope Plugins --
	-- use("tpope/vim-surround")

	-- -- Syntax Highlighting and Colors --
	-- use("PotatoesMaster/i3-vim-syntax")
	-- use("kovetskiy/sxhkd-vim")
	-- use("vim-python/python-syntax")
	-- use("ap/vim-css-color")
	-- use("nickeb96/fish.vim")

	-- -- Junegunn Choi Plugins --
	-- use("junegunn/goyo.vim")
	-- use("junegunn/limelight.vim")
	-- use("junegunn/vim-emoji")

	-- -- Other stuff --
	use("frazrepo/vim-rainbow")

	if packer_bootstrap then
		packer.sync()
	end
end)
