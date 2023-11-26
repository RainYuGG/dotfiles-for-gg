local status, db = pcall(require, "dashboard")
local home = os.getenv("HOME")

db.setup({
    theme = 'doom',
    config = {
        header = {
            "",
            "",
            "",
            " ██████╗  █████╗ ██╗███╗   ██╗██╗   ██╗██╗   ██╗ ██████╗  ██████╗  ", 
            " ██╔══██╗██╔══██╗██║████╗  ██║╚██╗ ██╔╝██║   ██║██╔════╝ ██╔════╝  ", 
            " ██████╔╝███████║██║██╔██╗ ██║ ╚████╔╝ ██║   ██║██║  ███╗██║  ███╗ ",
            " ██╔══██╗██╔══██║██║██║╚██╗██║  ╚██╔╝  ██║   ██║██║   ██║██║   ██║ ",
            " ██║  ██║██║  ██║██║██║ ╚████║   ██║   ╚██████╔╝╚██████╔╝╚██████╔╝ ",
            " ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═══╝   ╚═╝    ╚═════╝  ╚═════╝  ╚═════╝  ", 
            "",
            "",
            "",
            }, --your header
        center = {
            -- {
            -- 	icon = "  ",
            -- 	desc = "Recent sessions                         ",
            -- 	action = "SessionLoad",
            -- 	shortcut = "<LEADER> s l",
            -- },
            {
                icon = "                      ",
                desc = "Find recent files                       ",
                action = "Telescope oldfiles",
                shortcut = "<LEADER> f r",
            },
            {
                icon = "                      ",
                desc = "Find files                              ",
                action = "Telescope find_files find_command=rg,--hidden,--files",
                shortcut = "<LEADER> f f",
            },
            {
                icon = "                      ",
                desc = "File browser                            ",
                action = "Telescope file_browser",
                shortcut = "<LEADER> f b",
            },
            {
                icon = "                      ",
                desc = "Find word                               ",
                action = "Telescope live_grep",
                shortcut = "<LEADER> f w",
            },
            {
                icon = "                      ",
                desc = "Load new theme                          ",
                action = "Telescope colorscheme",
                shortcut = "<LEADER> t h",
            },
        },
        -- preview_file_height = 11,
        -- preview_file_width = 70,
        session_directory = "/Users/rainyugg/.config/nvim/session",
        footer = {"🪡🧵🪵🈹" }  --your footer
    }
})

-- linux🫥
--db.preview_command = 'ueberzug'
--db.preview_file_path = home .. '/.config/nvim/static/neovim.cat'
