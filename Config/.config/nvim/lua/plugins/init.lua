return {
	{
		"stevearc/conform.nvim",
		-- event = 'BufWritePre', -- uncomment for format on save
		opts = require("configs.conform"),
	},

	-- These are some examples, uncomment them if you want to see them work!
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("configs.lspconfig")
		end,
	},

	-- LSP Support
	-- Mason with integrated configuration
	{
		"williamboman/mason.nvim",
		dependencies = {
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		config = function()
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")

			-- enable mason and configure icons (your existing tweaks preserved)
			mason.setup({
				ui = {
					border = "rounded", -- Use rounded borders for the Mason window
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})

			-- Mason LSP config (your existing configuration preserved)
			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"bashls",
					"gopls",
					"cssls",
					"html",
					"pyright",
					"rust_analyzer",
					"ts_ls", -- tsserver → ts_ls (correct server name)
					"gofumpt", -- golang formatter
				},
				automatic_installation = true,
			})

			-- Mason tool installer (your existing configuration preserved)
			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
					"isort",
					"black", -- python formatter
					"pylint", -- python linter
					"shfmt", -- bash formatter
					-- "golines",
					-- "goimports",
					-- "eslint_d", -- js linter
					-- "nixfmt", -- nix formatter
					-- "rustfmt", -- rust formatter (uncomment if needed)
				},
				run_on_start = true,
				start_delay = 3000, -- 3 second delay
				debounce_hours = 5,
				integrations = {
					["mason-lspconfig"] = true,
					["mason-null-ls"] = true,
					["mason-nvim-dap"] = true,
				},
			})
		end,
	},

	-- test new blink
	-- { import = "nvchad.blink.lazyspec" },

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"vim",
				"lua",
				"vimdoc",
				"python",
				"rust",
				"bash",
				"markdown",
				"css",
				"html",
				"go",
				"gosum",
				"typescript",
				"tsx", -- Added typescript for better TS support
			},
		},
	},
}
