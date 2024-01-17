local M = {}

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
local menu_icons = {
	nvim_lsp = "λ",
	luasnip = "",
	buffer = "♽",
	path = "",
	nvim_lua = "",
}

M.config = function()
	-- CMP
	local has_cmp, cmp = pcall(require, "cmp")
	if has_cmp then
		local cmp_select = { behavior = cmp.SelectBehavior.Select }
		local cmp_sources = {
			{ name = "nvim_lsp" },
			{ name = "nvim_lsp_signature_help" },
			{ name = "nvim_lua" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "path" },
		}
		local cmp_mappings = {
			["<C-d>"] = cmp.mapping.scroll_docs(1),
			["<C-u>"] = cmp.mapping.scroll_docs(-1),
			["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
			["<C-j>"] = cmp.mapping.select_next_item(cmp_select),
			["<S-Tab>"] = cmp.mapping(function(fallback)
				local imported, luasnip = pcall(require, "luasnip")
				if cmp.visible() then
					cmp.mapping.abort()
				end
				if imported and luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
			["<Tab>"] = cmp.mapping(function(fallback)
				local imported, luasnip = pcall(require, "luasnip")
				if cmp.visible() then
					cmp.mapping.abort()
				end
				if imported and luasnip.expandable() then
					luasnip.expand()
				elseif imported and luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				else
					fallback()
				end
			end, { "i", "s" }),
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

		local cmp_config = {
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
		}

		vim.opt.completeopt = { "menu", "menuone", "noselect" }
		cmp.setup(cmp_config)
		-- `/` cmdline setup.
		cmp.setup.cmdline("/", {
			mapping = cmp_mappings,
			sources = {
				{ name = "buffer" },
			},
		})
		-- `:` cmdline setup.
		cmp.setup.cmdline(":", {
			mapping = cmp_mappings,
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
	end
end

return M
