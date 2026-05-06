local options = {
	formatters_by_ft = {
		lua = { "stylua" },
		css = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		nix = { "nixfmt" },
		bash = { "shfmt" },
		python = { "isort", "black" }, -- You can use both
		-- rust = { "rustfmt" },
	},

	format_on_save = {
		timeout_ms = 1000,
		lsp_fallback = true,
	},
}

return options
