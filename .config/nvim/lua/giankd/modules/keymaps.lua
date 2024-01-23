local M = {}

local function bind(op, outer_opts)
	outer_opts = outer_opts or { noremap = true }
	return function(lhs, rhs, opts)
		opts = vim.tbl_extend("force", outer_opts, opts or {})
		vim.keymap.set(op, lhs, rhs, opts)
	end
end

M.nmap = bind("n", { noremap = false })
M.nnoremap = bind("n")
M.vnoremap = bind("v")
M.xnoremap = bind("x")
M.inoremap = bind("i")

-- global keymaps
M.bootstrap = function()
	M.nnoremap("n", "nzz")
	M.nnoremap("N", "Nzz")
	M.inoremap("<C-c>", "<esc>")
	M.xnoremap("K", ":move '<-2<CR>gv-gv")
	M.xnoremap("J", ":move '>+1<CR>gv-gv")
end

return M
