return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/which-key.nvim",
	},
	event = { "VeryLazy", "BufReadPre *.*" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup({
			settings = {
				sync_on_ui_close = true,
				save_on_toggle = true,
			},
		})

		local hrp_mapping = {
			mode = { "n" },
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
			{ "<leader>h", group = "harpoon" },
			{
				"<leader>hh",
				function()
					harpoon:list():add()
				end,
				desc = "Add Mark",
			},
			{
				"<leader>hf",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "See all Marks",
			},
			{
				"<leader>hj",
				function()
					harpoon:list():next()
				end,
				desc = "Next Mark",
			},
			{
				"<leader>hk",
				function()
					harpoon:list():prev()
				end,
				desc = "Prev Mark",
			},
		}
		local wk = require("which-key")
		wk.add(hrp_mapping)
	end,
}
