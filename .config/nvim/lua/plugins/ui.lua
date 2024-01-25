local telescope_config = function()
	local actions = require("telescope.actions")
	local builtins = require("telescope.builtin")
	local whichkey = require("which-key")

	require("telescope").setup({
		pickers = {
			live_grep = {
				additional_args = function(opts)
					return { "--hidden" }
				end,
			},
		},
		defaults = {
			path_display = { "smart" },
			file_ignore_patterns = { "node_modules", ".git", ".yarn", "vendor" },
			file_sorter = require("telescope.sorters").get_fzf_sorter,
			prompt_prefix = " >",
			color_devicons = true,

			file_previewer = require("telescope.previewers").vim_buffer_cat.new,
			grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
			qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,

			mappings = {
				i = {
					["<C-j>"] = actions.move_selection_next,
					["<C-k>"] = actions.move_selection_previous,
					["<C-n>"] = actions.cycle_history_next,
					["<C-p>"] = actions.cycle_history_prev,
					["<C-x>"] = actions.delete_buffer,
					["<C-h>"] = "which_key",
				},
				n = {
					["q"] = actions.close,
				},
			},
			extensions = {
				-- TODO: Octo https://github.com/pwntester/octo.nvim
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true, -- override the generic sorter
					override_file_sorter = true, -- override the file sorter
					case_mode = "smart_case", -- or "ignore_case" or "respect_case"
					-- the default case_mode is "smart_case"
				},
			},
		},
	})

	-- Enable telescope fzf native, if installed
	local ok = pcall(require("telescope").load_extension, "fzf")
	if not ok then
		vim.notify("Unable to require FZF")
	end

	local keymaps = {
		f = {
			name = "Find",
			F = {
				function()
					builtins.find_files({
						find_command = { "rg", "--files", "--hidden", "-g", "!node_modules/**" },
					})
				end,
				"Browse All Files",
			},
			p = { builtins.git_files, "Git Files" },
			q = { builtins.quickfix, "QuickFix Elements" },
			s = { builtins.spell_suggest, "Spell Suggestions" },
			g = {
				name = "Git",
				b = { builtins.git_branches, "Branches" },
				s = { builtins.git_status, "Status" },
				S = { builtins.git_stash, "Stashes" },
				c = { builtins.git_commits, "Commits" },
				d = { builtins.git_bcommits, "Diff Commits" },
			},
			f = { builtins.live_grep, "Live Grep" },
			w = { builtins.current_buffer_fuzzy_find, "Current Buffer" },
			t = { "<cmd>TodoTelescope<CR>", "TODOs" },
		},
	}
	whichkey.register(keymaps, { silent = false, prefix = "<leader>" })
end

return {
	-- Netrw
	{ "tpope/vim-vinegar", lazy = false },
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-lua/popup.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"BurntSushi/ripgrep",
			"folke/which-key.nvim",
		},
		event = "VeryLazy",
		config = telescope_config,
	},
	{
		"numToStr/Comment.nvim",
		event = "BufEnter *.*",
		config = function()
			require("Comment").setup()
		end,
	},
}
