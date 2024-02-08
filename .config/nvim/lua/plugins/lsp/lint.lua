return {
	"mfussenegger/nvim-lint",
	dependencies = { "rshkarin/mason-nvim-lint" },
	event = { "BufReadPre *.*", "BufNewFile" },
	config = function()
		require("mason-nvim-lint").setup({
			ensure_installed = {
				-- "eslint_d",
				"vale",
				"codespell",
				"gdtoolkit",
				"jsonlint",
				"selene",
				"stylelint",
			},
			automatic_installation = true,
		})

		require("lint").linters_by_ft = {
			markdown = { "vale" },
			javascript = {
				"eslint",
				-- "eslint_d",
			},
			typescript = {
				"eslint",
				-- "eslint_d",
			},
			javascriptreact = {
				"eslint",
				-- "eslint_d",
			},
			typescriptreact = {
				"eslint",
				-- "eslint_d",
			},
			json = {
				"jsonlint",
			},
			lua = {
				"selene",
			},
			css = {
				"stylelint",
			},
			scss = {
				"stylelint",
			},
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			callback = function()
				require("lint").try_lint()
			end,
		})
	end,
}
