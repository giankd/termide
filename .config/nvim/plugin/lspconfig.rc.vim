lua << EOF
--vim.lsp.set_log_level("debug")
EOF

lua << EOF
local lsp_installer = require("nvim-lsp-installer")

lsp_installer.setup({
  automatic_installation = true,
  ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})

local nvim_lsp = require('lspconfig')
local protocol = require'vim.lsp.protocol'

-- Use an on_attach function to only map the following keys 
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Keymaps
  local whichkey = require('which-key')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  -- buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>d', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
  buf_set_keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)

  local keymap_c = {
    c = {
      name = "Code",
      R = { "<cmd>Trouble lsp_references<cr>", "Find All References" },
      -- a = { "<cmd>Telescope lsp_code_actions<CR>", "Code Action" },
      -- a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code Action" },
      a = { "<cmd>lua require('lspsaga.codeaction').code_action()<CR>", "Code Action" },
      -- d = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Line Diagnostics" },
      d = { "<cmd>Telescope diagnostics<CR>", "Diagnostics" },
      F = { "<cmd>Lspsaga lsp_finder<CR>", "Finder" },
      n = { "<cmd>Lspsaga rename<CR>", "Rename" },
      p = { "<cmd>Lspsaga preview_definition<CR>", "Definition" },
      r = { "<cmd>Telescope lsp_references<CR>", "Diagnostics" },
      t = { "<cmd>TroubleToggle<CR>", "Trouble" },
      i = { '<cmd>lua vim.lsp.buf.execute_command({command = "_typescript.organizeImports", arguments = {vim.fn.expand("%:p")}})<CR>', "Organize Imports" },
    },
    L = {
      name = "LSP",
      i = { "<cmd>LspInfo<CR>", "Lsp Info" },
      r = { "<cmd>LspRestart<CR>", "Lsp Restart" },
    }
  }

  local keymap_c_visual = {
    c = {
      name = "Code",
        a = { "<cmd>lua require('lspsaga.codeaction').range_code_action()<CR>", "Code Action" },
      }
    }

  -- formatting
  if client.resolved_capabilities.document_formatting then
      -- buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
      keymap_c.c.f = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "Format Document" }
  end
  if client.server_capabilities.documentFormattingProvider then
    vim.api.nvim_command [[augroup Format]]
    vim.api.nvim_command [[autocmd! * <buffer>]]
    vim.api.nvim_command [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_seq_sync()]]
    vim.api.nvim_command [[augroup END]]
  end

  local keymap_g = {
    g = {
      name = "Goto",
      d = { "<Cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
      D = { "<Cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
      s = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature Help" },
      i = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Goto Implementation" },
      t = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Goto Type Definition" },
    }
  }
  whichkey.register(keymap_c, { buffer = bufnr, prefix = "<leader>" })
  whichkey.register(keymap_c_visual, {mode = "v", buffer = bufnr, prefix = "<leader>" })
  whichkey.register(keymap_g, { buffer = bufnr, prefix = "<leader>" })

  --protocol.SymbolKind = { }
  protocol.CompletionItemKind = {
    '', -- Text
    '', -- Method
    '', -- Function
    '', -- Constructor
    '', -- Field
    '', -- Variable
    '', -- Class
    'ﰮ', -- Interface
    '', -- Module
    '', -- Property
    '', -- Unit
    '', -- Value
    '', -- Enum
    '', -- Keyword
    '﬌', -- Snippet
    '', -- Color
    '', -- File
    '', -- Reference
    '', -- Folder
    '', -- EnumMember
    '', -- Constant
    '', -- Struct
    '', -- Event
    'ﬦ', -- Operator
    '', -- TypeParameter
  }
end


-- Set up completion using nvim_cmp with LSP source
local capabilities = require('cmp_nvim_lsp').update_capabilities(
  vim.lsp.protocol.make_client_capabilities()
)

local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = capabilities,
  on_attach = on_attach,
}
nvim_lsp.util.default_config = vim.tbl_deep_extend(
  'force',
  nvim_lsp.util.default_config,
  lsp_defaults
)

nvim_lsp.tsserver.setup {
  on_attach = on_attach,
  filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
  capabilities = capabilities
}
local cssls_cap = capabilities
cssls_cap.textDocument.completion.completionItem.snippetSupport = true
-- TODO Commented due some nesting problems, solved by vscode
-- https://github.com/microsoft/vscode/issues/147674
nvim_lsp.cssls.setup {
  cmd = { "vscode-css-language-server", "--stdio" },
  filetypes = { "css", "sass", "scss" },
  on_attach = on_attach,
  capabilities = cssls_cap,
  settings = {
    css = {
      -- DISABLE WITH
      -- validate = false,
    },
  }
}

nvim_lsp.stylelint_lsp.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "css", "sass", "scss" },
  settings = {
    stylelintplus = {
      -- see available options in stylelint-lsp documentation
      autoFixOnSave = false,
      autoFixOnFormat = true,
    }
  }
}

nvim_lsp.vimls.setup {
  on_attach = on_attach,
  filetypes = { "vim" },
  capabilities = capabilities
}

nvim_lsp.sumneko_lua.setup {
  on_attach = on_attach,
  filetypes = { "lua" },
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
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
}

nvim_lsp.bashls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
}

nvim_lsp.diagnosticls.setup {
  on_attach = on_attach,
  filetypes = { 'javascript', 'javascriptreact', 'json', 'typescript', 'typescriptreact', 'css', 'less', 'scss', 'pandoc' },
  init_options = {
    linters = {
      eslint = {
        command = 'eslint_d',
        rootPatterns = { '.git' },
        debounce = 100,
        args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
        sourceName = 'eslint_d',
        parseJson = {
          errorsRoot = '[0].messages',
          line = 'line',
          column = 'column',
          endLine = 'endLine',
          endColumn = 'endColumn',
          message = '[eslint] ${message} [${ruleId}]',
          security = 'severity'
        },
        securities = {
          [2] = 'error',
          [1] = 'warning'
        }
        -- requiredFiles = { 'prettier.config.js', '.prettierrc', },
      },
    },
    filetypes = {
      javascript = 'eslint',
      javascriptreact = 'eslint',
      typescript = 'eslint',
      typescriptreact = 'eslint',
    },
    formatters = {
      eslint_d = {
        command = 'eslint_d',
        rootPatterns = { '.git' },
        args = { '--stdin', '--stdin-filename', '%filename', '--fix-to-stdout' },
        requiredFiles = { 'prettier.config.js', '.prettierrc' },
      },
      prettier = {
        -- TODO
        -- command = 'prettier_d_slim',
        command = 'prettier',
        rootPatterns = {
          '.prettierrc',
          '.prettierrc.json',
          '.prettierrc.toml',
          '.prettierrc.json',
          '.prettierrc.yml',
          '.prettierrc.yaml',
          '.prettierrc.json5',
          '.prettierrc.js',
          '.prettierrc.cjs',
          'prettier.config.js',
          'prettier.config.cjs',
        },
        requiredFiles = { 'prettier.config.js', '.prettierrc' },
        args = { '--stdin', '--stdin-filepath', '%filename' }
      }
    },
    formatFiletypes = {
      css = 'prettier',
      javascript = 'prettier',
      javascriptreact = 'prettier',
      scss = 'prettier',
      less = 'prettier',
      typescript = 'prettier',
      typescriptreact = 'prettier',
      json = 'prettier',
    }
  }
}

-- icon
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    underline = true,
    -- This sets the spacing and the prefix, obviously.
    virtual_text = {
      spacing = 4,
      prefix = ''
    }
  }
)

EOF
