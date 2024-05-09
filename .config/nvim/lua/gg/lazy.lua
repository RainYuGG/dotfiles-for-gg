local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {
    -- Gruvbox Colorscheme
    {
        "ellisonleao/gruvbox.nvim",
        priority = 1000,
        config = true,
        config = function()
            require("gruvbox").setup({})
            vim.cmd("colorscheme gruvbox")
        end
    },
    {
        "luisiacc/gruvbox-baby",
        lazy = false, -- make sure we load this during startup if it is your main colorscheme
        priority = 1000, -- make sure to load this before all the other start plugins
        -- config = function()
        --     require "config.gruvbox-baby"
        -- end
    },
  
    -- Dashboard is a nice start screen for nvim
    {
        "nvimdev/dashboard-nvim",
        lazy=false,
        config = function()
            require "config.dashboard"
        end
    },
  
    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies  = { 
            {"nvim-lua/plenary.nvim"},
            {"nvim-telescope/telescope-live-grep-args.nvim"},
            {"nvim-telescope/telescope-file-browser.nvim"},
            {"nvim-telescope/telescope-ui-select.nvim"},
        },
        config = function()
            require "config.telescope"
        end
    },
  
    -- Treesitter Syntax Highlighting
    {
        "nvim-treesitter/nvim-treesitter",
        dependencies = {
            "nvim-treesitter/nvim-treesitter-refactor",
            "RRethy/nvim-treesitter-textsubjects",
            "RRethy/nvim-treesitter-endwise",
            "windwp/nvim-ts-autotag",
        },
        build = ":TSUpdate",
        event = { "BufReadPost", "BufNewFile" },
        config = function()
            require "config.treesitter"
        end
    },
  
   {
        "rcarriga/nvim-notify",
        opts = {
            background_colour = "#000000",
        },
    },

   {
        "folke/noice.nvim",
        event = "VeryLazy",
        dependencies = {
            -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
            "MunifTanjim/nui.nvim",
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
             "rcarriga/nvim-notify",
        },
        config = function()
            require "config.noice"
        end
    },

    -- Language server
    -- {
    --     "neovim/nvim-lspconfig",
    --     config = function()
    --         require "config.lsp"
    --     end
    -- },
  
    {
        "L3MON4D3/LuaSnip",
        opt = {}
        -- install jsregexp (optional!).
        -- build = "make install_jsregexp"
    },

    -- {
    --     "hrsh7th/nvim-cmp",
    --     event = "VeryLazy",
    --     dependencies = {
    --         "neovim/nvim-lspconfig",
    --         "hrsh7th/cmp-nvim-lsp",
    --         "hrsh7th/cmp-buffer",
    --         "hrsh7th/cmp-path",
    --         "hrsh7th/cmp-cmdline",
    --         "saadparwaiz1/cmp_luasnip",
    --         "L3MON4D3/LuaSnip"
    --     },
    --     config = function()
    --         require "config.cmp"
    --     end
    -- },

    {
        "roobert/tailwindcss-colorizer-cmp.nvim",
        -- optionally, override the default options:
         config = function()
          require("tailwindcss-colorizer-cmp").setup({
            color_square_width = 2,
          })
        end
    },

    {
        "altermo/ultimate-autopair.nvim",
        event={"InsertEnter","CmdlineEnter"},
        branch="v0.6", --recomended as each new version will have breaking changes
        opts={
            --Config goes here
        },
    },

    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        }
    },

    -- Quick Comment
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
    },
    {
        "numToStr/Comment.nvim",
        lazy = false,
        config = function()
            require("Comment").setup({
                pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
            })
        end
    },

-- Which Key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        }
    },

    -- Bufferline
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        config = function()
            require("bufferline").setup({
                options = {
                    numbers = "ordinal"
                }
            })
        end
    },

    -- lualine (A better statusline)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("lualine").setup ()
        end 
    },

    -- -- File management --
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        init = function()
            vim.g.neo_tree_remove_legacy_commands = true
        end,
        cmd = "Neotree",
        event = "User EditingDirectory",
        -- config = function()
        --     require "config.neotree"
        -- end,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
    },

    {
        "vimwiki/vimwiki"
    },

    -- {
    --     "dinhhuy258/git.nvim",
    --     config = function()
    --         require "config/git"
    --     end
    -- },

    {
        "preservim/tagbar",
        event = "BufReadPost",
    },	
    --tagbar 
    --{"ryanoasis/vim-devicons"},

    {
      "christoomey/vim-tmux-navigator",
      cmd = {
        "TmuxNavigateLeft",
        "TmuxNavigateDown",
        "TmuxNavigateUp",
        "TmuxNavigateRight",
        "TmuxNavigatePrevious",
      },
      keys = {
        { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
        { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
        { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
        { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
        { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
    }
}


require("lazy").setup(plugin_specs, opts)
