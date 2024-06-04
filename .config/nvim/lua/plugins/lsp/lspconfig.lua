local server_configurations = {
	lua_ls = {
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
				completion = {
					callSnippet = "Replace",
				},
			},
		},
	},
	tsserver = {
		single_file_support = false,
	},
	cssls = {
		settings = {
			css = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
			less = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
			scss = {
				validate = true,
				lint = {
					unknownAtRules = "ignore",
				},
			},
		},
		single_file_support = false,
	},
	html = {
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
	},
	gopls = {
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
	},
	intelephense = {
		settings = {
			intelephense = {
				stubs = {
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
				},
			},
		},
	},
	bashls = {
		settings = {
			bashIde = {
				globPattern = "*@(.sh|.inc|.bash|.command)",
			},
		},
	},
	cssmodules_ls = {
		autostart = false,
	},
	tailwindcss = {
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
	},
	yamlls = {
		settings = {
			yaml = {
				schemas = {
					["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*", -- GitHub Workflow
					["https://bitbucket.org/atlassianlabs/intellij-bitbucket-references-plugin/raw/HEAD/src/main/resources/schemas/bitbucket-pipelines.schema.json"] = "bitbucket-pipelines.*.yml", -- Bitbucket pipelines
				},
			},
		},
	},
	-- ADD MORE SERVER CONFIGS
}

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre *.*", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"folke/which-key.nvim",
		"folke/neodev.nvim",
	},
	config = function()
		local neodev = require("neodev")
		local lspconfig = require("lspconfig")
		local cmp_lsp = require("cmp_nvim_lsp")
		local wk = require("which-key")

		-- debug lsp
		-- vim.lsp.set_log_level(0) -- 0 => TRACE

		-- Define servers configs
		neodev.setup({
			library = {
				enabled = true,
			},
		})
		local on_attach = function(client, bufnr)
			vim.notify("Attaching " .. client.name, { type = "info", title = "LSP" })

			local nnoremap = require("giankd.modules.keymaps").nnoremap

			-- Keymaps
			nnoremap("K", "<cmd>lua vim.lsp.buf.hover()<CR>")
			nnoremap("[d", "<cmd>lua vim.diagnostic.goto_prev({ float = true })<CR>")
			nnoremap(
				"[e",
				"<cmd>lua vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR , float = true })<CR>"
			)
			nnoremap("]d", "<cmd>lua vim.diagnostic.goto_next({ float = true })<CR>")
			nnoremap(
				"]e",
				"<cmd>lua vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR , float = true })<CR>"
			)

			local keymap_c = {
				c = {
					name = "Code",
					o = { "<cmd>Telescope lsp_workspace_symbols<CR>", "Outline" },
					l = { vim.diagnostic.open_float, "Line Diagnostic" },
					t = { "<cmd>Telescope lsp_type_definitions<CR>", "Find Type Definitions" },
					i = { "<cmd>Telescope lsp_implementations<CR>", "Find Implementations" },
					D = { "<cmd>Telescope lsp_definitions<CR>", "Find Definitions" },
					p = { vim.lsp.buf.declaration, "Find Declaration" },
					d = { "<cmd>Telescope diagnostics bufnr=0<CR>", "Document Diagnostics" },
					a = { vim.lsp.buf.code_action, "Code Action" },
					f = { "<cmd>Telescope lsp_references<CR>", "References" },
				},
			}

			local keymap_c_visual = {
				c = {
					name = "Code",
					a = { vim.lsp.buf.code_action, "Code Action" },
				},
			}

			local keymap_g = {
				g = {
					name = "Go To",
					d = { "<cmd>Glance definitions<CR>", "Definitions" },
					r = { "<cmd>Glance references<CR>", "References" },
					t = { "<cmd>Glance type_definitions<CR>", "Type Definition" },
					i = { "<cmd>Glance implementations<CR>", "Implementations" },
				},
			}

			wk.register(keymap_c, { buffer = bufnr, prefix = "<leader>" })
			wk.register(keymap_g, { buffer = bufnr, prefix = "<leader>" })
			wk.register(keymap_c_visual, { mode = "v", buffer = bufnr, prefix = "<leader>" })
		end
		local capabilities = cmp_lsp.default_capabilities()

		for server_name, server_config in pairs(server_configurations) do
			lspconfig[server_name].setup(vim.tbl_extend("force", server_config, {
				capabilities = capabilities,
				on_attach = on_attach,
			}))
		end
		-- End Define servers configs

		-- Define signs
		local gutter_signs = {
			Error = "⚠",
			Warn = "⛏",
			Hint = "◉",
			Info = "➜",
		}
		for type, icon in pairs(gutter_signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Define global keymaps
		local utils_keymap = {
			L = {
				name = "LSP",
				i = { "<cmd>LspInfo<CR>", "Lsp Info" },
				r = { "<cmd>LspRestart<CR>", "Lsp Restart" },
				l = { "<cmd>LspLog<CR>", "Lsp Log" },
			},
		}
		wk.register(utils_keymap, { buffer = nil, prefix = "<leader>" })
	end,
}
