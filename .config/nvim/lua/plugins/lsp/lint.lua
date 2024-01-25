return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	event = { "BufReadPre *.*", "BufNewFile" },
	config = function()
		local nls = require("null-ls")

		nls.setup({
			debug = false,
			diagnostics_format = "[#{c}] #{m} (#{s})",
			sources = {
				nls.builtins.code_actions.eslint_d,
				nls.builtins.code_actions.refactoring,
				nls.builtins.code_actions.xo,
				nls.builtins.completion.luasnip,
				nls.builtins.diagnostics.codespell,
				nls.builtins.diagnostics.dotenv_linter,
				nls.builtins.diagnostics.eslint_d,
				nls.builtins.diagnostics.jsonlint,
				nls.builtins.diagnostics.luacheck,
				nls.builtins.diagnostics.markdownlint,
				nls.builtins.diagnostics.phpcs,
				nls.builtins.diagnostics.revive,
				nls.builtins.diagnostics.selene,
				nls.builtins.diagnostics.shellcheck,
				nls.builtins.diagnostics.stylelint,
				nls.builtins.diagnostics.tsc,
				nls.builtins.diagnostics.write_good,
				nls.builtins.completion.spell,
			},
		})
	end,
}
