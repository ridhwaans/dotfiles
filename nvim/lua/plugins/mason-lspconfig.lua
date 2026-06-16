return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = {
			ensure_installed = {
				"bashls",
				"lua_ls",
				"clangd",
				"ts_ls",
				"pyright",
				"ruby_lsp",
			},
		},
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		opts = {
			ensure_installed = {
				"beautysh", -- formatter
				"clang-format", -- formatter
				"stylua", -- formatter
				"prettier", -- formatter
				"black", -- formatter
				"eslint_d", -- linter
				"ruff", -- linter
				"rubocop", -- linter
			},
		},
	},
}
