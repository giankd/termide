return {
	{
		"williamboman/mason.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"folke/which-key.nvim",
		},
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed or {}, {
				"tsserver",
				"cssls",
				"stylelint_lsp",
				"tailwindcss",
				"lua_ls",
				"vimls",
				"gopls",
				"bashls",
				"intelephense",
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
				"shfmt",
			})
			opts.ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			}
		end,
		config = function()
			local mason = require("mason")
			local m_lspconfig = require("mason-lspconfig")
			local whichkey = require("which-key")

			mason.setup({
				ui = {
					icons = {
						package_installed = "✓",
						package_pending = "➜",
						package_uninstalled = "✗",
					},
				},
			})
			m_lspconfig.setup({
				ensure_installed = {
					"tsserver",
					"cssls",
					"stylelint_lsp",
					"tailwindcss",
					"lua_ls",
					"vimls",
					"gopls",
					"bashls",
					"intelephense",
				},
				automatic_installation = true,
			})
			local utils_keymap = {
				L = {
					name = "LSP",
					m = { "<cmd>Mason<CR>", "Mason UI" },
				},
			}
			whichkey.register(utils_keymap, { buffer = nil, prefix = "<leader>" })
		end,
	},
}
