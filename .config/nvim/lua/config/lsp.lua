local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end

local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
	return
end

mason.setup({
	ui = {
		border = "rounded",
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})

-- Capabilities for nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_ok then
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Diagnostic UI
vim.diagnostic.config({
	float = { border = "rounded" },
})

local servers = {
	lua_ls = {
		settings = {
			Lua = {
				diagnostics = {
					globals = { "vim" },
				},
				workspace = {
					library = vim.api.nvim_get_runtime_file("", true),
					checkThirdParty = false,
				},
				telemetry = { enable = false },
			},
		},
	},
	pyright = {},
	gopls = {},
	bashls = {},
	jsonls = {},
}

mason_lspconfig.setup({
	ensure_installed = vim.tbl_keys(servers),
})

if vim.lsp.config then
	for server, config in pairs(servers) do
		config.capabilities = capabilities
		vim.lsp.config[server] = config
		vim.lsp.enable(server)
	end
else
	local lspconfig = require("lspconfig")
	for server, config in pairs(servers) do
		config.capabilities = capabilities
		lspconfig[server].setup(config)
	end
end
