local M = {}

M.config = function()
	local utils = require("giankd.notify")
	local ok, lsp = pcall(require, "lsp-zero")

	if not ok then
		utils.notify("Unable to require lsp-zero", { type = "error" })
		return
	end

	local Remap = require("giankd.keymap")
	local lsphelper = require("giankd.lsp-utils")
	local nnoremap = Remap.nnoremap

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
			"cssls",
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
				require("lspconfig").tsserver.setup({
					single_file_support = false,
					capabilities = lsp_capabilities,
				})
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
end

return M
