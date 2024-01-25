local kind = {
	Text = "⊜",
	Method = "⇒",
	Function = "⨐",
	Constructor = "",
	Field = "⤇",
	Variable = "𝛂",
	Class = "𝛀",
	Interface = "",
	Module = "",
	Property = "",
	Unit = "",
	Value = "𝞈",
	Enum = "",
	Keyword = "⚿",
	Snippet = "⟬⟭",
	Color = "",
	File = "⊳",
	Reference = "※",
	Folder = "",
	EnumMember = "",
	Constant = "ℇ",
	Struct = "λ",
	Event = "⇝",
	Operator = "±",
	TypeParameter = "",
}
local cmp_sources = {
	{ name = "nvim_lsp" },
	{ name = "nvim_lsp_signature_help" },
	{ name = "nvim_lua" },
	{ name = "luasnip" },
	{ name = "buffer" },
	{ name = "path" },
}

local menu_icons = {
	nvim_lsp = "λ",
	luasnip = "",
	buffer = "♽",
	path = "",
	nvim_lua = "",
}
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-nvim-lua",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/cmp-nvim-lsp-signature-help",
		"saadparwaiz1/cmp_luasnip",
		"L3MON4D3/LuaSnip",
		"rafamadriz/friendly-snippets",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		require("luasnip.loaders.from_vscode").lazy_load()

		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		local cmp_mappings = {
			["<C-d>"] = cmp.mapping.scroll_docs(1),
			["<C-u>"] = cmp.mapping.scroll_docs(-1),
			["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
			["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
			["<C-x>"] = cmp.mapping.complete({
				config = {
					sources = cmp_sources,
				},
			}),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({
				behavior = cmp.ConfirmBehavior.Replace,
				select = true,
			}),
		}

		cmp.setup({
			mapping = cmp_mappings,
			sources = cmp_sources,
			window = {
				completion = cmp.config.window.bordered(),
				documentation = cmp.config.window.bordered(),
			},
			formatting = {
				fields = { "menu", "abbr", "kind" },
				format = function(entry, item)
					item.menu = (menu_icons[entry.source.name] or "")
						.. " ("
						.. (entry.source.name or "Unknown source")
						.. ")"
					item.kind = kind[item.kind]
					return item
				end,
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
		})
		-- `/` cmdline setup.
		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer" },
			},
		})
		-- `:` cmdline setup.
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "buffer" },
				{
					name = "cmdline",
					option = {
						ignore_cmds = { "Man", "!" },
					},
				},
			}),
		})
	end,
}
