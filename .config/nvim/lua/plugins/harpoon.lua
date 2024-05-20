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
			["h"] = {
				name = "Harpoon",
				h = {
					function()
						harpoon:list():add()
					end,
					"Add Mark",
				},
				f = {
					function()
						harpoon.ui:toggle_quick_menu(harpoon:list())
					end,
					"See all Marks",
				},
				j = {
					function()
						harpoon:list():next()
					end,
					"Next Mark",
				},
				k = {
					function()
						harpoon:list():prev()
					end,
					"Prev Mark",
				},
			},
		}
		local wk = require("which-key")
		wk.register(hrp_mapping, {
			mode = "n", -- Normal mode
			prefix = "<leader>",
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
		})
	end,
}
