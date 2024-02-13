return {
	"mfussenegger/nvim-lint",
	dependencies = { "rshkarin/mason-nvim-lint" },
	event = { "BufReadPre *.*", "BufNewFile" },
	config = function()
		require("mason-nvim-lint").setup({
			ensure_installed = {
				"vale",
				"codespell",
				"gdtoolkit",
				"jsonlint",
				"selene",
				"stylelint",
			},
			automatic_installation = false,
		})

		require("lint").linters_by_ft = {
			markdown = { "vale" },
			javascript = {
				"eslint",
			},
			typescript = {
				"eslint",
			},
			javascriptreact = {
				"eslint",
			},
			typescriptreact = {
				"eslint",
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
