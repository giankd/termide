local nvim_lsp = require("lspconfig")
local trouble = require("trouble")
local bulb = require("nvim-lightbulb")
local Remap = require("giankd.keymap")
local lsphelper = require("giankd.lsp-utils")
local nnoremap = Remap.nnoremap

-- UI Config
-- Diagnostics
trouble.setup({
	position = "bottom", -- position of the list can be: bottom, top, left, right
	height = 10, -- height of the trouble list when position is top or bottom
	width = 50, -- width of the list when position is left or right
	icons = true, -- use devicons for filenames
	mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
	fold_open = "", -- icon used for open folds
	fold_closed = "", -- icon used for closed folds
	group = true, -- group results by file
	padding = true, -- add an extra new line on top of the list
	action_keys = { -- key mappings for actions in the trouble list
		-- map to {} to remove a mapping, for example:
		-- close = {},
		close = "q", -- close the list
		cancel = { "<esc>", "<c-c>" }, -- cancel the preview and get back to your last window / buffer / cursor
		refresh = "r", -- manually refresh
		jump = { "<cr>", "<tab>" }, -- jump to the diagnostic or open / close folds
		open_split = { "<c-x>" }, -- open buffer in new split
		open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
		open_tab = { "<c-t>" }, -- open buffer in new tab
		jump_close = { "o" }, -- jump to the diagnostic and close the list
		toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
		toggle_preview = "P", -- toggle auto_preview
		hover = "K", -- opens a small popup with the full multiline message
		preview = "p", -- preview the diagnostic location
		close_folds = { "zM", "zm" }, -- close all folds
		open_folds = { "zR", "zr" }, -- open all folds
		toggle_fold = { "zA", "za" }, -- toggle fold of current file
		previous = "k", -- previous item
		next = "j", -- next item
	},
	indent_lines = true, -- add an indent guide below the fold icons
	auto_open = false, -- automatically open the list when you have diagnostics
	auto_close = true, -- automatically close the list when you have no diagnostics
	auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
	auto_fold = false, -- automatically fold a file trouble list at creation
	auto_jump = {}, -- for the given modes, automatically jump if there is only a single result
	signs = {
		-- icons / text used for a diagnostic
		error = "",
		warning = "",
		hint = "",
		information = "",
		other = "➜",
	},
	use_diagnostic_signs = false, -- enabling this will use the signs defined in your lsp client
})
-- Code Actions
bulb.setup({
	-- LSP client names to ignore
	-- Example: {"sumneko_lua", "null-ls"}
	ignore = {},
	sign = {
		enabled = false,
		-- Priority of the gutter sign
		priority = 10,
	},
	float = {
		enabled = true,
		-- Text to show in the popup float
		text = "",
		-- Available keys for window options:
		-- - height     of floating window
		-- - width      of floating window
		-- - wrap_at    character to wrap at for computing height
		-- - max_width  maximal width of floating window
		-- - max_height maximal height of floating window
		-- - pad_left   number of columns to pad contents at left
		-- - pad_right  number of columns to pad contents at right
		-- - pad_top    number of lines to pad contents at top
		-- - pad_bottom number of lines to pad contents at bottom
		-- - offset_x   x-axis offset of the floating window
		-- - offset_y   y-axis offset of the floating window
		-- - anchor     corner of float to place at the cursor (NW, NE, SW, SE)
		-- - winblend   transparency of the window (0-100)
		win_opts = {},
	},
	virtual_text = {
		enabled = true,
		-- Text to show at virtual text
		text = "",
		-- highlight mode to use for virtual text (replace, combine, blend), see :help nvim_buf_set_extmark() for reference
		hl_mode = "blend",
	},
	status_text = {
		enabled = true,
		-- Text to provide when code actions are available
		text = "",
		-- Text to provide when no actions are available
		text_unavailable = "",
	},
	autocmd = {
		enabled = true,
		-- see :help autocmd-pattern
		pattern = { "*" },
		-- see :help autocmd-events
		events = { "CursorHold", "CursorHoldI" },
	},
})
-- Icons
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
	-- ensure_installed = { "sumneko_lua" },
	automatic_installation = true,
})

-- On LSP Server Attach
local on_attach = function(client, bufnr)
	print("Attaching " .. client.name)

	local serverCapabilities = client.server_capabilities
	if serverCapabilities.document_formatting or serverCapabilities.documentFormattingProvider then
		local status, f = pcall(require, "giankd.formatter")
		if not status then
			print("Unable to require formatter module")
		else
			f.EnableFormatOnSave()
		end
		-- else
		-- 	print("Client " .. client.name .. " has no document_formatting or documentFormattingProvider")
	end

	-- Keymaps
	nnoremap("K", lsphelper.hover)
	nnoremap("[d", lsphelper.goto_prev_d)
	nnoremap("]d", lsphelper.goto_next_d)
	nnoremap("[e", lsphelper.goto_prev_e)
	nnoremap("]e", lsphelper.goto_next_e)

	local whichkey = require("which-key")
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

	-- Enable icons
	protocol.CompletionItemKind = protocolCompletionIcons
end

-- List of LSP Servers and configs for each
-- Set up completion using nvim_cmp with LSP source
local capabilities = require("cmp_nvim_lsp").default_capabilities()

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

nvim_lsp.tailwindcss.setup({
	on_attach = on_attach,
	capabilities = capabilities,
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

nvim_lsp.svelte.setup({
	on_attach = on_attach,
	capabilities = capabilities,
})

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
	underline = true,
	-- This sets the spacing and the prefix, obviously.
	virtual_text = {
		spacing = 4,
		prefix = "✘",
	},
})
