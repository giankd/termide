local ignore_filetypes = { "sql" }

return {
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		dependencies = { "folke/which-key.nvim" },
		cmd = { "ConformInfo" },
		config = function()
			require("conform").setup({
				-- Define formatters
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					["markdown"] = { { "prettierd", "prettier" } },
					["markdown.mdx"] = { { "prettierd", "prettier" } },
					["json"] = { { "prettierd", "prettier" } },
					["javascript"] = { { "prettierd", "prettier", "dprint" } },
					["javascriptreact"] = { { "prettierd", "prettier", "dprint" } },
					["typescript"] = { { "prettierd", "prettier", "dprint" } },
					["typescriptreact"] = { { "prettierd", "prettier", "dprint" } },
					["css"] = { { "prettierd", "prettier" } },
					["scss"] = { { "prettierd", "prettier" } },
				},
				-- Set up format-on-save
				format_on_save = function(bufnr)
					-- Disable autoformat on certain filetypes
					if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
						return
					end
					-- Disable with a global or buffer-local variable
					if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
						return
					end
					-- Disable autoformat for files in a certain path
					local bufname = vim.api.nvim_buf_get_name(bufnr)
					if bufname:match("/node_modules/") then
						return
					end
					-- TODO ...additional logic...
					return { timeout_ms = 500, lsp_fallback = true }
				end,
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
			})
			local whichkey = require("which-key")
			whichkey.register({
				F = {
					name = "Format",
					["F"] = {
						function()
							require("conform").format({ async = true, lsp_fallback = true })
						end,
						"Format buffer",
					},
					["t"] = {
						function()
							vim.b.disable_autoformat = not vim.b.disable_autoformat
						end,
						"Toggle format on save for this buffer",
					},
					["T"] = {
						function()
							vim.g.disable_autoformat = not vim.g.disable_autoformat
						end,
						"Toggle format on save for all buffers",
					},
					["i"] = {
						function()
							vim.notify(
								"Format on save "
									.. (vim.g.disable_autoformat and "DISABLED" or "enabled")
									.. "\nFormat on save this buffer "
									.. (vim.b.disable_autoformat and "disabled" or "enabled")
							)
						end,
						"Show format on save state",
					},
				},
			}, { prefix = "<leader>", mode = "n", noremap = true })
		end,
	},
}
