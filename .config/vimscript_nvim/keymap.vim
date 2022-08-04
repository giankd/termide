" Keymaps
lua << EOF

local remap = vim.api.nvim_set_keymap
local default_opts = { noremap = true, silent = true }

remap("n", "n", "nzz", default_opts)
remap("n", "N", "Nzz", default_opts)
remap("i", "<C-c>", "<esc>", default_opts)
remap("x", "K", ":move '<-2<CR>gv-gv", default_opts)
remap("x", "J", ":move '>+1<CR>gv-gv", default_opts)

EOF
