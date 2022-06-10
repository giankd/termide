set completeopt=menu,menuone,noinsert,noselect

lua <<EOF
local cmp = require'cmp'
local lspkind = require'lspkind'
require('luasnip.loaders.from_vscode').lazy_load()
local select_opt = {behavior = cmp.SelectBehavior.Select, }

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-k>'] = cmp.mapping.select_prev_item(select_opt),
    ['<C-j>'] = cmp.mapping.select_next_item(select_opt),
    ['<S-Tab>'] = cmp.mapping.select_prev_item(select_opt),
    ['<Tab>'] = cmp.mapping.select_next_item(select_opt),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true
    }),
  }),
  sources = cmp.config.sources({
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 3},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  }),
  window = {
    documentation = cmp.config.window.bordered()
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = lspkind.cmp_format({with_text = false, maxwidth = 50})
  }
})

vim.cmd [[highlight! default link CmpItemKind CmpItemMenuDefault]]
EOF

