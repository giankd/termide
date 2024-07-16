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
			spell_suggest = {
				theme = "cursor",
			},
			current_buffer_fuzzy_find = {
				theme = "dropdown",
			},
			diagnostics = {
				theme = "dropdown",
			},
			git_branches = {
				theme = "dropdown",
			},
			git_status = {
				theme = "dropdown",
			},
			git_stash = {
				theme = "dropdown",
			},
			git_commits = {
				theme = "dropdown",
			},
			git_bcommits = {
				theme = "dropdown",
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
		silent = false,
		{ "<leader>f", group = "find" },
		{
			"<leader>fl",
			function()
				builtins.find_files({
					find_command = { "rg", "--files", "--hidden", "-g", "!node_modules/**" },
				})
			end,
			desc = "Browse All Files",
		},
		{ "<leader>fp", builtins.git_files, desc = "Git Files" },
		{ "<leader>fq", builtins.quickfix, desc = "QuickFix Elements" },
		{ "<leader>fs", builtins.spell_suggest, desc = "Spell Suggestions" },
		{ "<leader>fg", group = "find_git" },
		{ "<leader>fgb", builtins.git_branches, desc = "Branches" },
		{ "<leader>fgs", builtins.git_status, desc = "Status" },
		{ "<leader>fgS", builtins.git_stash, desc = "Stashes" },
		{ "<leader>fgc", builtins.git_commits, desc = "Commits" },
		{ "<leader>fgd", builtins.git_bcommits, desc = "Diff Commits" },
		{ "<leader>ff", builtins.live_grep, desc = "Live Grep" },
		{ "<leader>fw", builtins.current_buffer_fuzzy_find, desc = "Current Buffer" },
		{ "<leader>ft", "<cmd>TodoTelescope<CR>", desc = "TODOs" },
	}
	whichkey.add(keymaps)
end

return {
	-- Netrw
	-- { "tpope/vim-vinegar", lazy = false },
	-- File explorer
	{
		"stevearc/oil.nvim",
		lazy = false,
		config = function()
			local oil = require("oil")
			oil.setup({
				-- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
				skip_confirm_for_simple_edits = true,
				-- Oil will automatically delete hidden buffers after this delay
				-- You can set the delay to false to disable cleanup entirely
				-- Note that the cleanup process only starts when none of the oil buffers are currently displayed
				cleanup_delay_ms = 2000,
				lsp_file_methods = {
					-- Time to wait for LSP file operations to complete before skipping
					timeout_ms = 1000,
				},
				keymaps = {
					["g?"] = "actions.show_help",
					["<CR>"] = "actions.select",
					["<C-v>"] = "actions.select_vsplit",
					["<C-h>"] = "actions.select_split",
					["<C-t>"] = "actions.select_tab",
					["<C-p>"] = "actions.preview",
					["<C-q>"] = "actions.close",
					["<C-l>"] = "actions.refresh",
					["-"] = "actions.parent",
					["_"] = "actions.open_cwd",
					["`"] = "actions.cd",
					["~"] = "actions.tcd",
					["gs"] = "actions.change_sort",
					["gx"] = "actions.open_external",
					["g."] = "actions.toggle_hidden",
					["g\\"] = "actions.toggle_trash",
				},
				use_default_keymaps = true,
				view_options = {
					-- Show files and directories that start with "."
					show_hidden = true,
					-- This function defines what is considered a "hidden" file
					is_hidden_file = function(name, bufnr)
						return vim.startswith(name, ".")
					end,
					-- Sort file names in a more intuitive order for humans. Is less performant,
					-- so you may want to set to false if you work with large directories.
					natural_order = true,
					sort = {
						-- sort order can be "asc" or "desc"
						-- see :help oil-columns to see which columns are sortable
						{ "type", "asc" },
						{ "name", "asc" },
					},
				},
				-- Extra arguments to pass to SCP when moving/copying files over SSH
				extra_scp_args = {},
				-- EXPERIMENTAL support for performing file operations with git
				git = {
					-- Return true to automatically git add/mv/rm files
					add = function(path)
						return false
					end,
					mv = function(src_path, dest_path)
						return false
					end,
					rm = function(path)
						return false
					end,
				},
				-- Configuration for the floating progress window
				progress = {
					max_width = 0.9,
					min_width = { 40, 0.4 },
					width = nil,
					max_height = { 10, 0.9 },
					min_height = { 5, 0.1 },
					height = nil,
					border = "rounded",
					minimized_border = "none",
					win_options = {
						winblend = 0,
					},
				},
				-- Configuration for the floating keymaps help window
				keymaps_help = {
					border = "rounded",
				},
			})
			local keymaps = require("giankd.modules.keymaps")
			keymaps.nnoremap("-", "<cmd>Oil<CR>", { desc = "Open Oil (File Explorer)" })
		end,
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
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
