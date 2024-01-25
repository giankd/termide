return {
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_in_macro = true,
			enable_check_bracket_line = false,
			check_ts = true,
		},
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			{
				"nvim-treesitter/nvim-treesitter-context",
				opts = {
					enable = true,
				},
			},
			"windwp/nvim-ts-autotag",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				ignore_install = {
					"help",
				},
				ensure_installed = {
					"tsx",
					"toml",
					"bash",
					"php",
					"json",
					"javascript",
					"typescript",
					"markdown",
					"yaml",
					"svelte",
					"swift",
					"html",
					"scss",
					"css",
				},
				sync_install = false,
				auto_install = true,

				autotag = {
					enable = true,
				},
				indent = {
					enable = true,
					disable = {},
				},
				highlight = {
					enable = true,
					disable = {},
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			-- you can enable a preset for easier configuration
			presets = {
				bottom_search = true, -- use a classic bottom cmdline for search
				command_palette = true, -- position the cmdline and popupmenu together
				long_message_to_split = true, -- long messages will be sent to a split
				inc_rename = false, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = false, -- add a border to hover docs and signature help
			},
		},
		dependencies = {
			"MunifTanjim/nui.nvim",
			{
				"rcarriga/nvim-notify",
				opts = {

					background_colour = "#000000",
					timeout = 2000,
					icons = {
						DEBUG = "",
						ERROR = "",
						INFO = "",
						TRACE = "✎",
						WARN = "",
					},
					stages = "slide",
				},
			},
		},
	},
	{
		dependencies = {
		},
		config = function()
		end,
	},
}
