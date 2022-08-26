local nvim_lsp = require("lspconfig")
local Remap = require("giankd.keymap")
local nnoremap = Remap.nnoremap
local saga = require("lspsaga")

saga.init_lsp_saga({
	-- Options with default value
	-- "single" | "double" | "rounded" | "bold" | "plus"
	border_style = "rounded",
	--the range of 0 for fully opaque window (disabled) to 100 for fully
	--transparent background. Values between 0-30 are typically most useful.
	saga_winblend = 0,
	-- when cursor in saga window you config these to move
	move_in_saga = { prev = "<C-p>", next = "<C-n>" },
	-- Error, Warn, Info, Hint
	-- and diagnostic_header can be a function type
	-- must return a string and when diagnostic_header
	-- is function type it will have a param `entry`
	-- entry is a table type has these filed
	-- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
	diagnostic_header = { "✘ ", "❯ ", "✦ ", "◈ " },
	-- show diagnostic source
	show_diagnostic_source = true,
	-- add bracket or something with diagnostic source, just have 2 elements
	diagnostic_source_bracket = {},
	-- preview lines of lsp_finder and definition preview
	max_preview_lines = 10,
	code_action_icon = "ϟ ",
	-- if true can press number to execute the codeaction in codeaction window
	code_action_num_shortcut = true,
	code_action_lightbulb = {
		enable = true,
		sign = true,
		enable_in_insert = true,
		sign_priority = 20,
		virtual_text = true,
	},
	finder_action_keys = {
		open = "o",
		vsplit = "s",
		split = "i",
		tabe = "t",
		quit = "q",
		scroll_down = "<C-j>",
		scroll_up = "<C-k>", -- quit can be a table
	},
	code_action_keys = {
		quit = "q",
		exec = "<CR>",
	},
	rename_action_quit = "<ESC>",
	rename_in_select = true,
	definition_preview_icon = "  ",
})

local protocol = require("vim.lsp.protocol")
local protocolCompletionIcons = {
	"", -- Text
	"", -- Method
	"", -- Function
	"", -- Constructor
	"", -- Field
	"", -- Variable
	"", -- Class
	"ﰮ", -- Interface
	"", -- Module
	"", -- Property
	"", -- Unit
	"", -- Value
	"", -- Enum
	"", -- Keyword
	"﬌", -- Snippet
	"", -- Color
	"", -- File
	"", -- Reference
	"", -- Folder
	"", -- EnumMember
	"", -- Constant
	"", -- Struct
	"", -- Event
	"ﬦ", -- Operator
	"", -- TypeParameter
}

-- local augroup = vim.api.nvim_create_augroup
-- local autocmd = vim.api.nvim_create_autocmd
-- FormatGroup = augroup('Format', {})

-- local function EnableFormatOnSave()
--   autocmd('BufferWritePre', {
--     group = FormatGroup,
--     pattern = '*',
--     callback = function()
--       vim.lsp.buf.formatting_seq_sync()
--     end
--   })
-- end
--
-- local function ToggleFormatOnSave()
--   if not vim.fn.exists('#Format#BufWritePre') then
--     EnableFormatOnSave()
--   else
--     autocmd('BufferWritePre', {
--       group = FormatGroup,
--       command = 'silent!'
--     })
--   end
-- end
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
	-- ensure_installed = { "sumneko_lua" },
	automatic_installation = true,
})

local on_attach = function(client, bufnr)
	print("Attaching " .. client.name)

	if client.resolved_capabilities.document_formatting then
		require("giankd.formatter").EnableFormatOnSave()
	end

	-- Keymaps
	nnoremap("K", "<cmd>Lspsaga hover_doc<CR>")
	nnoremap("<C-j>", function()
		require("lspsaga.action").smart_scroll_with_saga(1)
	end)
	nnoremap("<C-k>", function()
		require("lspsaga.action").smart_scroll_with_saga(-1)
	end)
	nnoremap("]d", function()
		require("lspsaga.diagnostic").goto_prev()
	end)
	nnoremap("[d", function()
		require("lspsaga.diagnostic").goto_next()
	end)
	nnoremap("[e", function()
		require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
	end)
	nnoremap("]e", function()
		require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
	end)

	local whichkey = require("which-key")
	local keymap_c = {
		c = {
			name = "Code",
			a = { "<cmd>Lspsaga code_action<CR>", "Code Action" },
			d = { "<cmd>Telescope diagnostics<CR>", "Diagnostics" },
			f = { "<cmd>Lspsaga lsp_finder<CR>", "Finder" },
			s = { "<cmd>Lspsaga signature_help<CR>", "Signature Help" },
			n = { "<cmd>Lspsaga rename<CR>", "Rename" },
			p = { "<cmd>Lspsaga preview_definition<CR>", "Definition" },
			l = { "<cmd>Lspsaga show_line_diagnostics<CR>", "Line Diagnostic" },
			c = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "Cursor Diagnostic" },
			r = { "<cmd>Telescope lsp_references<CR>", "References" },
			i = {
				'<cmd>lua vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})<CR>',
				"Organize Imports",
			},
		},
		L = {
			name = "LSP",
			i = { "<cmd>LspInfo<CR>", "Lsp Info" },
			r = { "<cmd>LspRestart<CR>", "Lsp Restart" },
			m = { "<cmd>Mason<CR>", "Mason UI" },
		},
	}

	local keymap_c_visual = {
		c = {
			name = "Code",
			a = { "<cmd>Lspsaga range_code_action<CR>", "Code Action" },
		},
	}

	local keymap_g = {
		g = {
			name = "Goto",
			d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
			D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
			s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
			i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
			t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
		},
	}
	whichkey.register(keymap_c, { buffer = bufnr, prefix = "<leader>" })
	whichkey.register(keymap_c_visual, { mode = "v", buffer = bufnr, prefix = "<leader>" })
	whichkey.register(keymap_g, { buffer = bufnr, prefix = "<leader>" })

	-- Enable icons
	protocol.CompletionItemKind = protocolCompletionIcons
end

-- Set up completion using nvim_cmp with LSP source
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

local lsp_defaults = {
	flags = {
		debounce_text_changes = 150,
	},
	capabilities = capabilities,
	on_attach = on_attach,
}
nvim_lsp.util.default_config = vim.tbl_deep_extend("force", nvim_lsp.util.default_config, lsp_defaults)

nvim_lsp.tsserver.setup({
	on_attach = on_attach,
	filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
	capabilities = capabilities,
})
local cssls_cap = capabilities
cssls_cap.textDocument.completion.completionItem.snippetSupport = true
-- TODO Commented due some nesting problems, solved by vscode
-- https://github.com/microsoft/vscode/issues/147674
nvim_lsp.cssls.setup({
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "sass", "scss" },
	on_attach = on_attach,
	capabilities = cssls_cap,
	settings = {
		css = {
			-- DISABLE WITH
			-- validate = false,
		},
	},
})

nvim_lsp.stylelint_lsp.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	filetypes = { "css", "sass", "scss" },
	settings = {
		stylelintplus = {
			-- see available options in stylelint-lsp documentation
			autoFixOnSave = false,
			autoFixOnFormat = true,
		},
	},
})

nvim_lsp.vimls.setup({
	on_attach = on_attach,
	filetypes = { "vim" },
	capabilities = capabilities,
	init_options = {
		diagnostic = {
			enable = true,
		},
		indexes = {
			count = 3,
			gap = 100,
			projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
			runtimepath = true,
		},
		iskeyword = "@,48-57,_,192-255,-#",
		runtimepath = "",
		suggest = {
			fromRuntimepath = true,
			fromVimruntime = true,
		},
		vimruntime = "",
	},
})

nvim_lsp.sumneko_lua.setup({
	on_attach = on_attach,
	filetypes = { "lua" },
	capabilities = capabilities,
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
		},
	},
})

nvim_lsp.bashls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

nvim_lsp.gopls.setup({
	on_attach = on_attach,
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
	capabilities = capabilities,
})

nvim_lsp.diagnosticls.setup({
	on_attach = on_attach,
	filetypes = {
		"javascript",
		"javascriptreact",
		"json",
		"typescript",
		"typescriptreact",
		"css",
		"less",
		"scss",
		"pandoc",
	},
	init_options = {
		linters = {
			eslint = {
				command = "eslint_d",
				rootPatterns = { ".git" },
				debounce = 100,
				args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
				sourceName = "eslint_d",
				parseJson = {
					errorsRoot = "[0].messages",
					line = "line",
					column = "column",
					endLine = "endLine",
					endColumn = "endColumn",
					message = "[eslint] ${message} [${ruleId}]",
					security = "severity",
				},
				securities = {
					[2] = "error",
					[1] = "warning",
				},
				-- requiredFiles = { 'prettier.config.js', '.prettierrc', },
			},
		},
		filetypes = {
			javascript = "eslint",
			javascriptreact = "eslint",
			typescript = "eslint",
			typescriptreact = "eslint",
		},
		-- formatters = {
		--   eslint_d = {
		--     command = 'eslint_d',
		--     rootPatterns = { '.git' },
		--     args = { '--stdin', '--stdin-filename', '%filename', '--fix-to-stdout' },
		--     requiredFiles = { 'prettier.config.js', '.prettierrc' },
		--   },
		--   prettier = {
		--     -- TODO
		--     -- command = 'prettier_d_slim',
		--     command = 'prettier',
		--     rootPatterns = {
		--       'package.json',
		--       '.prettierrc',
		--       '.prettierrc.json',
		--       '.prettierrc.toml',
		--       '.prettierrc.json',
		--       '.prettierrc.yml',
		--       '.prettierrc.yaml',
		--       '.prettierrc.json5',
		--       '.prettierrc.js',
		--       '.prettierrc.cjs',
		--       'prettier.config.js',
		--       'prettier.config.cjs',
		--     },
		--     requiredFiles = { 'package.json', 'prettier.config.js', '.prettierrc' },
		--     args = { '--stdin', '--stdin-filepath', '%filename' }
		--   }
		-- },
		-- formatFiletypes = {
		--   css = 'prettier',
		--   javascript = 'prettier',
		--   javascriptreact = 'prettier',
		--   scss = 'prettier',
		--   less = 'prettier',
		--   typescript = 'prettier',
		--   typescriptreact = 'prettier',
		--   json = 'prettier',
		-- }
	},
})

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	-- This sets the spacing and the prefix, obviously.
	virtual_text = {
		spacing = 4,
		prefix = "",
	},
})
