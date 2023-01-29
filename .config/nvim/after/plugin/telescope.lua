local telescope = require("telescope")
local actions = require("telescope.actions")
local builtins = require("telescope.builtin")
local notifier = require("giankd.notify")

telescope.setup({
	pickers = {
		live_grep = {
			additional_args = function(opts)
				return { "--hidden" }
			end,
		},
	},
	defaults = {
		path_display = "smart",
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
		},
	},
})

-- Enable telescope fzf native, if installed
local ok = pcall(require("telescope").load_extension, "fzf")
if not ok then
	notifier.notify("FZF not installed", { type = "warn", title = "Telescope" })
end
