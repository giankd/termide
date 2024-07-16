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
				mode = { "n" },
				silent = true,
				{ "<leader>S", group = "serp" },
				{ "<leader>Ss", '<cmd>lua require("spectre").toggle()<CR>', desc = "Toggle Spectre" },
				{
					"<leader>Sw",
					'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
					desc = "Search current word",
				},
				{
					"<leader>Sp",
					'<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
					desc = "Search on current file",
				},
			}
			local v_keymaps = {
				mode = "v",
				silent = true,
				{
					"<leader>Sw",
					'<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
					desc = "Search current word",
				},
			}
			wk.add(n_keymaps)
			wk.add(v_keymaps)
		else
			vim.notify("Unable to require WK")
		end
	end,
}
