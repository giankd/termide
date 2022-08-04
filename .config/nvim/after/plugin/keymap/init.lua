local Remap = require("giankd.keymap")
local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap
local xnoremap = Remap.xnoremap

nnoremap("n", "nzz")
nnoremap("N", "Nzz")
inoremap("<C-c>", "<esc>")
xnoremap("K", ":move '<-2<CR>gv-gv")
xnoremap("J", ":move '>+1<CR>gv-gv")
