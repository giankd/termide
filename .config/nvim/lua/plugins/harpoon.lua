return {
	"ThePrimeagen/harpoon",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/which-key.nvim",
	},
	event = { "BufReadPre *.*" },
	config = function()
		local mark = require("harpoon.mark")
		local ui = require("harpoon.ui")
		local wk = require("which-key")

		local hrp_mapping = {
			["h"] = {
				name = "Harpoon",
				h = { mark.add_file, "Add Mark" },
				f = { ui.toggle_quick_menu, "See all Marks" },
				j = { ui.nav_next, "Next Mark" },
				k = { ui.nav_prev, "Prev Mark" },
			},
		}
		wk.register(hrp_mapping, {
			mode = "n", -- Normal mode
			prefix = "<leader>",
			noremap = true, -- use `noremap` when creating keymaps
			nowait = false, -- use `nowait` when creating keymaps
		})

		require("harpoon").setup({
			menu = {
				width = vim.api.nvim_win_get_width(0) - 4,
			},
		})
	end,
}
