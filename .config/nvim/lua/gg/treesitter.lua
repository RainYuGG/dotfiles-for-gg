local status, ts = pcall(require, "nvim-treesitter.configs")
if not status then
	return
end

ts.setup({
	-- If TS highlights are not enabled at all, or disabled via `disable` prop,
	-- highlighting will fallback to default Vim syntax highlighting
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = { "org" }, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
	},
    -- Before install parsers, u should modify the branch version in the lockfile in nvim-treesitter directory.
	-- ensure_installed = { "org", "lua", "python" , "typescript" }, -- Or run :TSUpdate org
})
