return {
	"nvim-pack/nvim-spectre",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"BurntSushi/ripgrep",
		"nvim-tree/nvim-web-devicons",
	},
	event = "VeryLazy",
	config = function()
		local ok, wk = pcall(require, "which-key")
		if ok then
			local n_keymaps = {
				S = {
					name = "Search and Replace",
					t = {
						'<cmd>lua require("spectre").toggle()<CR>',
						"Toggle Spectre",
					},
					w = {
						'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
						"Search current word",
					},
					p = {
						'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
						"Search on current file",
					},
				},
			}
			local v_keymaps = {
				S = {
					name = "Search and Replace",
					w = {
						'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
						"Search current word",
					},
				},
			}
			wk.register(n_keymaps, { silent = true, mode = "n" })
			wk.register(v_keymaps, { silent = true, mode = "v" })
		else
			vim.notify("Unable to require WK")
		end
	end,
}
