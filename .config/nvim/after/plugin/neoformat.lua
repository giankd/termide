local whichkey = require("which-key")

-- autocmd('BufWritePre', {
--   group = format_group,
--   pattern = '*',
--   callback = function()
--     vim.cmd('Neoformat')
--   end,
-- })
vim.g.neoformat_try_node_exe = 1

local normal_opts = {
	mode = "n", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}
local visual_opts = {
	mode = "v", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}

local nmappings = {
	F = {
		name = "Format",
		f = { "<Cmd>Neoformat<CR>", "Format File" },
		t = { "<Cmd>lua require('giankd.formatter').ToggleFormatOnSave()<CR>", "Toggle Format on Save" },
	},
}
local vmappings = {
	F = {
		name = "Format",
		f = { "<Cmd>Neoformat<CR>", "Format Selection" },
	},
}

whichkey.register(nmappings, normal_opts)
whichkey.register(vmappings, visual_opts)
