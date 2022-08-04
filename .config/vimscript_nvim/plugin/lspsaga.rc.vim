lua << EOF
local saga = require 'lspsaga'

saga.init_lsp_saga {
  error_sign = '✘',
  warn_sign = '❯',
  hint_sign = '✦',
  infor_sign = '◈',
  border_style = "round",
}

EOF

nnoremap <silent> <C-j> <Cmd>Lspsaga diagnostic_jump_next<CR>
nnoremap <silent> <C-k> <Cmd>Lspsaga diagnostic_jump_prev<CR>
" nnoremap <silent>K <Cmd>Lspsaga hover_doc<CR>
nnoremap <silent>K <Cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
" scroll down hover doc or scroll in definition preview
nnoremap <silent> <C-f> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>
" scroll up hover doc
nnoremap <silent> <C-b> <cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>
inoremap <silent> <C-k> <Cmd>Lspsaga signature_help<CR>
inoremap <silent> <C-l> <Cmd>lua require('lspsaga.hover').render_hover_doc()<CR>
