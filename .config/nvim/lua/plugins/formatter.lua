return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				-- Customize or remove this keymap to your liking
				"<leader>F",
				function()
					require("conform").format({ async = true, lsp_fallback = true })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		-- Everything in opts will be passed to setup()
		opts = {
			-- Define your formatters
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "isort", "black" },
				["markdown"] = { { "prettierd", "prettier" } },
				["markdown.mdx"] = { { "prettierd", "prettier" } },
				["javascript"] = { { "prettierd", "prettier", "dprint" } },
				["javascriptreact"] = { { "prettierd", "prettier", "dprint" } },
				["typescript"] = { { "prettierd", "prettier", "dprint" } },
				["typescriptreact"] = { { "prettierd", "prettier", "dprint" } },
			},
			-- Set up format-on-save
			format_on_save = { timeout_ms = 500, lsp_fallback = true },
			-- Customize formatters
			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},
				dprint = {
					condition = function(ctx)
						return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
					end,
				},
			},
		},
	},
}
