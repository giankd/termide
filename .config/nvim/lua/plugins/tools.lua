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
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					enable_close = true, -- Auto close tags
					enable_rename = true, -- Auto rename pairs of tags
					enable_close_on_slash = true, -- Auto close on trailing </
				},
			})
		end,
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
					"regex",
				},
				sync_install = false,
				auto_install = true,
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
				inc_rename = true, -- enables an input dialog for inc-rename.nvim
				lsp_doc_border = true, -- add a border to hover docs and signature help
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
		"folke/neoconf.nvim",
		lazy = false,
		opts = {
			-- name of the local settings files
			local_settings = ".neoconf.json",
			-- name of the global settings file in your Neovim config directory
			global_settings = "neoconf.json",
			-- import existing settings from other plugins
			import = {
				vscode = true, -- local .vscode/settings.json
				coc = true, -- global/local coc-settings.json
				nlsp = true, -- global/local nlsp-settings.nvim json settings
			},
			-- send new configuration to lsp clients when changing json settings
			live_reload = true,
			-- set the filetype to jsonc for settings files, so you can use comments
			-- make sure you have the jsonc treesitter parser installed!
			filetype_jsonc = true,
			plugins = {
				-- configures lsp clients with settings in the following order:
				-- - lua settings passed in lspconfig setup
				-- - global json settings
				-- - local json settings
				lspconfig = {
					enabled = true,
				},
				-- configures jsonls to get completion in .nvim.settings.json files
				jsonls = {
					enabled = true,
					-- only show completion in json settings for configured lsp servers
					configured_servers_only = true,
				},
				-- configures lua_ls to get completion of lspconfig server settings
				lua_ls = {
					-- by default, lua_ls annotations are only enabled in your neovim config directory
					enabled_for_neovim_config = true,
					-- explicitely enable adding annotations. Mostly relevant to put in your local .nvim.settings.json file
					enabled = false,
				},
			},
		},
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		event = { "VeryLazy" },
		cmd = { "TodoTelescope" },
		opts = {
			signs = true, -- show icons in the signs column
			sign_priority = 8, -- sign priority
			-- keywords recognized as todo comments
			keywords = {
				FIX = {
					icon = " ", -- icon used for the sign, and in search results
					color = "error", -- can be a hex color, or a named color (see below)
					alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- a set of other keywords that all map to this FIX keywords
					-- signs = false, -- configure signs for some keywords individually
				},
				TODO = { icon = " ", color = "info" },
				HACK = { icon = " ", color = "warning" },
				WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
				PERF = { icon = "⏲ ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
				NOTE = { icon = " ", color = "hint", alt = { "INFO" } },
				TESTING = { icon = "⏲ ", color = "test", alt = { "PASSED", "FAILED" } },
			},
			gui_style = {
				fg = "NONE", -- The gui style to use for the fg highlight group.
				bg = "BOLD", -- The gui style to use for the bg highlight group.
			},
			merge_keywords = true, -- when true, custom keywords will be merged with the defaults
			-- highlighting of the line containing the todo comment
			-- * before: highlights before the keyword (typically comment characters)
			-- * keyword: highlights of the keyword
			-- * after: highlights after the keyword (todo text)
			highlight = {
				multiline = true, -- enable multine todo comments
				multiline_pattern = "^.", -- lua pattern to match the next multiline from the start of the matched keyword
				multiline_context = 10, -- extra lines that will be re-evaluated when changing a line
				before = "", -- "fg" or "bg" or empty
				keyword = "wide", -- "fg", "bg", "wide", "wide_bg", "wide_fg" or empty. (wide and wide_bg is the same as bg, but will also highlight surrounding characters, wide_fg acts accordingly but with fg)
				after = "fg", -- "fg" or "bg" or empty
				pattern = [[.*<(KEYWORDS)\s*]], -- pattern or table of patterns, used for highlighting (vim regex)
				comments_only = true, -- uses treesitter to match keywords in comments only
				max_line_len = 400, -- ignore lines longer than this
				exclude = {}, -- list of file types to exclude highlighting
			},
			-- list of named colors where we try to extract the guifg from the
			-- list of highlight groups or use the hex color if hl not found as a fallback
			colors = {
				error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
				warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
				info = { "DiagnosticInfo", "#2563EB" },
				hint = { "DiagnosticHint", "#10B981" },
				default = { "Identifier", "#7C3AED" },
				test = { "Identifier", "#FF00FF" },
			},
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
				},
				-- regex that will be used to match keywords.
				-- don't replace the (KEYWORDS) placeholder
				pattern = [[\b(KEYWORDS)\b]], -- ripgrep regex
			},
		},
	},
	{
		"smjonas/inc-rename.nvim",
		dependencies = {
			"folke/noice.nvim",
			"folke/which-key.nvim",
		},
		event = { "BufReadPre *.*" },
		cmd = { "IncRename" },
		config = function()
			local keymaps = require("giankd.modules.keymaps")
			require("inc_rename").setup()
			keymaps.nnoremap("<leader>cn", function()
				return ":IncRename " .. vim.fn.expand("<cword>")
			end, { expr = true })
		end,
	},
}
