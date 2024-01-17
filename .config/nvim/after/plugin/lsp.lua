local utils = require("giankd.notify")
local ok, lsp = pcall(require, "lsp-zero")

if not ok then
	utils.notify("Unable to require lsp-zero", { type = "error" })
	return
end

local Remap = require("giankd.keymap")
local lsphelper = require("giankd.lsp-utils")
local nnoremap = Remap.nnoremap

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
local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Installer
require("mason").setup({
	ui = {
		icons = {
			package_installed = "✓",
			package_pending = "➜",
			package_uninstalled = "✗",
		},
	},
})
require("mason-lspconfig").setup({
	automatic_installation = true,
	ensure_installed = {
		"tsserver",
		"eslint",
		-- "cssls",
		"stylelint_lsp",
		"tailwindcss",
		"lua_ls",
		"vimls",
		"gopls",
		"bashls",
		"intelephense",
	},
	handlers = {
		lsp.default_setup,
		lua_ls = function()
			local lua_opts = lsp.nvim_lua_ls()
			require("lspconfig").lua_ls.setup(lua_opts)
		end,
		tsserver = function()
			require("lspconfig").tsserver.setup({ capabilities = lsp_capabilities })
		end,
		eslint = function()
			require("lspconfig").eslint.setup({
				format = false,
			})
		end,
		cssls = function()
			local tw_config_path = vim.fn.stdpath("config") .. "/after/plugin/tailwind-atrules.json"
			local cssls_capabilities = require("cmp_nvim_lsp").default_capabilities()
			cssls_capabilities.textDocument.completion.completionItem.snippetSupport = true
			require("lspconfig").cssls.setup({
				capabilities = cssls_capabilities,
				settings = {
					css = {
						lint = {
							customData = { tw_config_path },
						},
					},
					less = {
						customData = { tw_config_path },
					},
					scss = {
						customData = { tw_config_path },
					},
				},
			})
		end,
		stylelint_lsp = function()
			require("lspconfig").stylelint_lsp.setup({
				settings = {
					stylelintplus = {
						-- see available options in stylelint-lsp documentation
						autoFixOnSave = false,
						autoFixOnFormat = true,
					},
				},
			})
		end,
		html = function()
			require("lspconfig").html.setup({
				settings = {
					init_options = {
						configurationSection = { "html", "css", "javascript" },
						embeddedLanguages = {
							css = true,
							javascript = true,
						},
						provideFormatter = false,
					},
				},
			})
		end,
		gopls = function()
			require("lspconfig").gopls.setup({
				settings = {
					gopls = {
						experimentalPostfixCompletions = true,
						analyses = {
							unusedparams = true,
							shadow = true,
						},
						staticcheck = true,
					},
				},
			})
		end,
		intelephense = function()
			-- Default stubs picked from https://emacs-lsp.github.io/lsp-mode/page/lsp-intelephense/
			-- Added wordpress stub
			local intelephense_stubs = {
				"apache",
				"bcmath",
				"bz2",
				"calendar",
				"com_dotnet",
				"Core",
				"ctype",
				"curl",
				"date",
				"dba",
				"dom",
				"enchant",
				"exif",
				"fileinfo",
				"filter",
				"fpm",
				"ftp",
				"gd",
				"hash",
				"iconv",
				"imap",
				"interbase",
				"intl",
				"json",
				"ldap",
				"libxml",
				"mbstring",
				"mcrypt",
				"meta",
				"mssql",
				"mysqli",
				"oci8",
				"odbc",
				"openssl",
				"pcntl",
				"pcre",
				"PDO",
				"pdo_ibm",
				"pdo_mysql",
				"pdo_pgsql",
				"pdo_sqlite",
				"pgsql",
				"Phar",
				"posix",
				"pspell",
				"readline",
				"recode",
				"Reflection",
				"regex",
				"session",
				"shmop",
				"SimpleXML",
				"snmp",
				"soap",
				"sockets",
				"sodium",
				"SPL",
				"sqlite3",
				"standard",
				"superglobals",
				"sybase",
				"sysvmsg",
				"sysvsem",
				"sysvshm",
				"tidy",
				"tokenizer",
				"wddx",
				"wordpress",
				"xml",
				"xmlreader",
				"xmlrpc",
				"xmlwriter",
				"Zend",
				"OPcache",
				"zip",
				"zlib",
			}

			require("lspconfig").intelephense.setup({
				settings = {
					intelephense = {
						stubs = intelephense_stubs,
					},
				},
			})
		end,
		tailwindcss = function()
			utils.notify("Attaching tailwind with config", { type = "info", title = "LSP" })
			require("lspconfig").tailwindcss.setup({
				settings = {
					tailwindCSS = {
						classAttributes = { "class", "className", "class:list", "classList", "ngClass" },
						lint = {
							cssConflict = "warning",
							invalidApply = "error",
							invalidConfigPath = "error",
							invalidScreen = "error",
							invalidTailwindDirective = "error",
							invalidVariant = "error",
							recommendedVariantOrder = "warning",
						},
						validate = true,
					},
				},
			})
		end,
	},
})

-- Global Utils keymaps
local whichkey = require("which-key")
local utils_keymap = {
	L = {
		name = "LSP",
		i = { "<cmd>LspInfo<CR>", "Lsp Info" },
		r = { "<cmd>LspRestart<CR>", "Lsp Restart" },
		m = { "<cmd>Mason<CR>", "Mason UI" },
	},
}
whichkey.register(utils_keymap, { buffer = nil, prefix = "<leader>" })

-- On LSP Server Attach
local on_attach = function(client, bufnr)
	utils.notify("Attaching " .. client.name, { type = "info", title = "LSP" })

	local serverCapabilities = client.server_capabilities
	local status, f = pcall(require, "giankd.formatter")
	if not status then
		utils.notify("Unable to require formatter module", { type = "error", title = "System" })
	else
		if serverCapabilities.document_formatting or serverCapabilities.documentFormattingProvider then
			f.EnableNativeFormatter()
			utils.notify("LSP formatter found: " .. client.name, { type = "info", title = "LSP" })
		end
		f.EnableFormatOnSave()
	end

	-- Keymaps
	nnoremap("K", lsphelper.hover)
	nnoremap("[d", lsphelper.goto_prev_d)
	nnoremap("]d", lsphelper.goto_next_d)
	nnoremap("[e", lsphelper.goto_prev_e)
	nnoremap("]e", lsphelper.goto_next_e)

	local keymap_c = {
		c = {
			name = "Code",
			a = { lsphelper.code_actions, "Code Action" },
			d = { lsphelper.buf_diagnostics, "Document Diagnostics" },
			D = { lsphelper.workspace_diagnostics, "Workspace Diagnostics" },
			f = { lsphelper.finder, "Finder" },
			s = { lsphelper.signature_help, "Signature Help" },
			n = { lsphelper.rename, "Rename" },
			p = { lsphelper.peek_definition, "Definition" },
			o = { lsphelper.outline, "Outline" },
			l = { lsphelper.line_diagnostics, "Line Diagnostic" },
			c = { lsphelper.cursor_diagnostics, "Cursor Diagnostic" },
			r = { lsphelper.references, "References" },
			i = {
				lsphelper.organize_imports,
				"Organize Imports",
			},
		},
	}

	local keymap_c_visual = {
		c = {
			name = "Code",
			a = { lsphelper.code_actions, "Code Action" },
		},
	}

	local keymap_g = {
		g = {
			name = "Goto",
			d = { lsphelper.goto_definition, "Definition" },
			D = { lsphelper.goto_declaration, "Declaration" },
			i = { lsphelper.goto_implementation, "Goto Implementation" },
			t = { lsphelper.goto_type_def, "Goto Type Definition" },
		},
	}
	whichkey.register(keymap_c, { buffer = bufnr, prefix = "<leader>" })
	whichkey.register(keymap_c_visual, { mode = "v", buffer = bufnr, prefix = "<leader>" })
	whichkey.register(keymap_g, { buffer = bufnr, prefix = "<leader>" })
end

lsp.set_sign_icons({
	error = "⚠",
	warn = "⛏",
	hint = "◉",
	info = "➜",
})

-- Setup neovim lua configuration
local has_neodev, neodev = pcall(require, "neodev")
if has_neodev then
	neodev.setup()
end

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	-- This sets the spacing and the prefix, obviously.
	virtual_text = {
		spacing = 4,
		prefix = "✘",
	},
	update_in_insert = true,
})

lsp.on_attach(on_attach)
require("luasnip.loaders.from_vscode").lazy_load()

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

-- UI
local has_glance, glance = pcall(require, "glance")
if has_glance then
	local actions = glance.actions

	glance.setup({
		height = 22,
		zindex = 45,
		-- By default glance will open preview "embedded" within your active window
		-- when `detached` is enabled, glance will render above all existing windows
		-- and won't be restiricted by the width of your active window
		-- detached = true,
		-- Or use a function to enable `detached` only when the active window is too small
		-- (default behavior)
		detached = function(winid)
			return vim.api.nvim_win_get_width(winid) < 85
		end,
		preview_win_opts = { -- Configure preview window options
			cursorline = true,
			number = true,
			wrap = true,
		},
		border = {
			enable = true, -- Show window borders. Only horizontal borders allowed
			top_char = "―",
			bottom_char = "―",
		},
		list = {
			position = "left", -- Position of the list window 'left'|'right'
			width = 0.33, -- 33% width relative to the active window, min 0.1, max 0.5
		},
		theme = { -- This feature might not work properly in nvim-0.7.2
			enable = true, -- Will generate colors for the plugin based on your current colorscheme
			mode = "auto", -- 'brighten'|'darken'|'auto', 'auto' will set mode based on the brightness of your colorscheme
		},
		mappings = {
			list = {
				["j"] = actions.next, -- Bring the cursor to the next item in the list
				["k"] = actions.previous, -- Bring the cursor to the previous item in the list
				["<Tab>"] = actions.next_location, -- Bring the cursor to the next location skipping groups in the list
				["<S-Tab>"] = actions.previous_location, -- Bring the cursor to the previous location skipping groups in the list
				["<C-u>"] = actions.preview_scroll_win(5),
				["<C-d>"] = actions.preview_scroll_win(-5),
				["v"] = actions.jump_vsplit,
				["s"] = actions.jump_split,
				["t"] = actions.jump_tab,
				["o"] = actions.jump,
				["<leader>o"] = actions.enter_win("preview"), -- Focus preview window
				["q"] = actions.close,
				["Q"] = actions.close,
				["<Esc>"] = actions.close,
				-- ['<Esc>'] = false -- disable a mapping
			},
			preview = {
				["Q"] = actions.close,
				["q"] = actions.close,
				["<Tab>"] = actions.next_location,
				["<S-Tab>"] = actions.previous_location,
				["<leader>o"] = actions.enter_win("list"), -- Focus list window
			},
		},
		folds = {
			fold_closed = "",
			fold_open = "",
			folded = true, -- Automatically fold list on startup
		},
		indent_lines = {
			enable = true,
			icon = "│",
		},
		winbar = {
			enable = false, -- Available strating from nvim-0.8+
		},
		hooks = {
			-- Don't open glance when there is only one result and it is located in the current buffer, open otherwise
			before_open = function(results, open, jump, method)
				local uri = vim.uri_from_bufnr(0)
				if #results == 1 then
					local target_uri = results[1].uri or results[1].targetUri

					if target_uri == uri then
						jump(results[1])
					else
						open(results)
					end
				else
					open(results)
				end
			end,
		},
	})
end
