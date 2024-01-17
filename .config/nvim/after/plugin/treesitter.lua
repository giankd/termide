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

local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
