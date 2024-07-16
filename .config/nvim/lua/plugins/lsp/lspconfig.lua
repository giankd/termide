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
		settings = {
			single_file_support = false,
			init_options = {
				hostInfo = "neovim",
			},
		},
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
	rust_analyzer = {},
	-- ADD MORE SERVER CONFIGS
}

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre *.*", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"folke/which-key.nvim",
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "luvit-meta/library", words = { "vim%.uv" } },
				},
			},
		},
		{ "Bilal2453/luvit-meta", ft = "lua", lazy = true },
	},
	config = function()
		local lspconfig = require("lspconfig")
		local cmp_lsp = require("cmp_nvim_lsp")
		local wk = require("which-key")

		-- debug lsp
		-- vim.lsp.set_log_level(0) -- 0 => TRACE

		-- Define servers configs
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
				{ "<leader>c", group = "code" },
				{ "<leader>co", "<cmd>Telescope lsp_workspace_symbols<CR>", desc = "Outline" },
				{ "<leader>cl", vim.diagnostic.open_float, desc = "Line Diagnostic" },
				{ "<leader>ct", "<cmd>Telescope lsp_type_definitions<CR>", desc = "Find Type Definitions" },
				{ "<leader>ci", "<cmd>Telescope lsp_implementations<CR>", desc = "Find Implementations" },
				{ "<leader>cD", "<cmd>Telescope lsp_definitions<CR>", desc = "Find Definitions" },
				{ "<leader>cp", vim.lsp.buf.declaration, desc = "Find Declaration" },
				{ "<leader>cd", "<cmd>Telescope diagnostics bufnr=0<CR>", "Document Diagnostics (Telescope)" },
				{ "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action" },
				{ "<leader>cf", "<cmd>Telescope lsp_references<CR>", desc = "References" },
			}

			local keymap_c_visual = {
				{ "<leader>ca", vim.lsp.buf.code_action, "Code Action", mode = "v" },
			}

			local keymap_g = {
				{ "<leader>g", group = "goto" },
				{ "<leader>gd", "<cmd>Glance definitions<CR>", desc = "Definitions" },
				{ "<leader>gr", "<cmd>Glance references<CR>", desc = "References" },
				{ "<leader>gt", "<cmd>Glance type_definitions<CR>", desc = "Type Definition" },
				{ "<leader>gi", "<cmd>Glance implementations<CR>", desc = "Implementations" },
			}

			wk.add(keymap_c)
			wk.add(keymap_g)
			wk.add(keymap_c_visual)
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
			{ "<leader>L", group = "lsp" },
			{ "<leader>Li", "<cmd>LspInfo<CR>", desc = "Lsp Info" },
			{ "<leader>Lr", "<cmd>LspRestart<CR>", desc = "Lsp Restart" },
			{ "<leader>Ll", "<cmd>LspLog<CR>", desc = "Lsp Log" },
		}
		wk.add(utils_keymap)
	end,
}
