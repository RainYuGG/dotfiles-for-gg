local status, telescope = pcall(require, "telescope")
if not status then
	return
end

telescope.setup({
	-- defaults = {
	-- 	borderchars = {
	-- 	  prompt = { "─", " ", " ", " ", "─", "─", " ", " " },
	-- 	  results = { " " },
	-- 	  preview = { " " },
	-- 	},
	-- },
	extensions = {
		file_browser = {
			-- theme = "ivy",
			-- disables netrw and use telescope-file-browser in its place
			hijack_netrw = true,
			mappings = {
				["i"] = {
					-- your custom insert mode mappings
				},
				["n"] = {
					-- your custom normal mode mappings
				},
			},
		},
	},
})

require("telescope").load_extension("file_browser")
require("telescope").load_extension("ui-select")
-- require("telescope").extensions.live_grep_args.live_grep_args()
