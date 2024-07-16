local keymaps = require("giankd.modules.keymaps")
local nmap = keymaps.nmap
local xnoremap = keymaps.xnoremap

local function diffCurrentLines()
	local mode = vim.fn.mode()
	if mode == "V" or mode == "v" then
		local chm = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
		vim.api.nvim_feedkeys(chm, "n", true)
		vim.defer_fn(function()
			local initial_mark = vim.api.nvim_buf_get_mark(0, "<")
			local final_mark = vim.api.nvim_buf_get_mark(0, ">")
			local initial_pos = initial_mark[0]
			local final_pos = final_mark[0]
			if initial_pos == 0 and final_pos == 0 then
				print(vim.inspect(initial_mark), vim.inspect(final_mark))
				vim.notify("Impossible to get selection", vim.log.levels.WARN)
				return
			end
			vim.cmd("'<,'>GcLog")
		end, 100)
		return
	end
	vim.notify("Using Diff Current Lines NOT in VMode", vim.log.levels.ERROR)
end

local static_keymaps_signs = {
	mode = { "n" },
	noremap = true,
	{ "<leader>G", group = "git" },
	{ "<leader>GB", "<cmd>Git blame<cr>", desc = "Blame mode (Fugitive)" },
	{ "<leader>Gl", "<cmd>0GcLog<cr>", desc = "Previous versions" },
	{ "<leader>Gm", "<cmd>G mergetool<cr>", desc = "Merge Tool" },
	{ "<leader>Go", "<cmd>Gvdiffsplit!<CR>", desc = "Open Diff Tool" },
	{ "<leader>Gc", group = "conflicts" },
	{ "<leader>Gck", "[c", desc = "Previous conflict" },
	{ "<leader>Gcj", "]c", desc = "Next conflict" },
	{ "<leader>Gcc", "dp", desc = "Put" },
	{ "<leader>Gch", "<cmd>diffget //2<CR>", desc = "Get from left" },
	{ "<leader>Gcl", "<cmd>diffget //3<CR>", desc = "Get from right" },
	{ "<leader>Gcs", "<cmd>Gwrite!<CR>", desc = "Resolve" },
}

local static_keymaps_diff = {
	mode = { "n" },
	noremap = true,
	{ "<leader>d", group = "diffview" },
	{ "<leader>db", "<cmd>DiffviewFileHistory<CR>", desc = "Current Branch" },
	{ "<leader>df", "<cmd>DiffviewFileHistory %<CR>", desc = "Current File" },
	{ "<leader>dd", "<cmd>DiffviewOpen<CR>", desc = "Current changes" },
	{ "<leader>do", "<cmd>DiffviewOpen origin/main...HEAD<CR>", desc = "Origin main" },
	{ "<leader>dl", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Last commit" },
	{ "<leader>dr", "<cmd>DiffviewRefresh<CR>", desc = "Refresh" },
	{ "<leader>dc", "<cmd>DiffviewClose<CR>", desc = "Close" },
}

return {
	{
		"tpope/vim-fugitive",
		cmd = { "Git", "GcLog", "Gvdiffsplit", "G" },
	},
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufEnter *.*" },
		dependencies = { "folke/which-key.nvim" },
		config = function()
			local whichkey = require("which-key")
			whichkey.add(static_keymaps_signs)
			require("gitsigns").setup({
				signs = {
					add = {
						text = "│",
						show_count = true,
					},
					change = {
						text = "│",
						show_count = true,
					},
					delete = {
						text = "_",
						show_count = true,
					},
					topdelete = {
						text = "‾",
						show_count = true,
					},
					changedelete = {
						text = "~",
						show_count = true,
					},
					untracked = {
						text = "┆",
						show_count = true,
					},
				},
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir = {
					interval = 1000,
					follow_files = true,
				},
				attach_to_untracked = false,
				current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts = {
					virt_text = true,
					virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
				sign_priority = 6,
				update_debounce = 100,
				status_formatter = nil, -- Use default
				max_file_length = 40000,
				preview_config = {
					-- Options passed to nvim_open_win
					border = "single",
					style = "minimal",
					relative = "cursor",
					row = 0,
					col = 1,
				},
				on_attach = function(bufnr)
					local gs = require("gitsigns")

					-- Navigation
					nmap("]g", function()
						if vim.wo.diff then
							return "]g"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					nmap("[g", function()
						if vim.wo.diff then
							return "[g"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					local keymap_g_n = {
						mode = { "n" },
						noremap = true,
						{ "<leader>G", group = "git" },
						{
							"<leader>Ga",
							function()
								gs.setqflist(0)
							end,
							desc = "Current Buffer Changes",
						},
						{
							"<leader>GA",
							function()
								gs.setqflist("all")
							end,
							desc = "All Changes",
						},
						{ "<leader>GS", gs.stage_buffer, desc = "Stage Buffer" },
						{ "<leader>GR", gs.reset_buffer, desc = "Reset Buffer" },
						{ "<leader>Gu", gs.undo_stage_hunk, desc = "Unstage Hunk" },
						{ "<leader>GP", gs.preview_hunk, desc = "Preview Hunk" },
						{ "<leader>Gp", gs.preview_hunk_inline, desc = "Preview Hunk" },
						{
							"<leader>Gb",
							function()
								gs.blame_line({ full = true })
							end,
							desc = "Blame Line (Signs)",
						},
						{ "<leader>Gd", gs.diffthis, desc = "Diff" },
						{
							"<leader>GD",
							function()
								gs.diffthis("~1", {
									vertical = true,
								})
							end,
							desc = "Diff Last Commit",
						},
						{ "<leader>Gtb", gs.toggle_current_line_blame, desc = "Toggle Blame Line" },
						{ "<leader>Gtd", gs.toggle_deleted, desc = "Toggle Deleted" },
						{ "<leader>Gtl", gs.toggle_linehl, desc = "Toggle Line HL" },
					}

					local keymap_g_v = {
						mode = { "v" },
						noremap = true,
						{ "<leader>Gs", "<cmd>Gitsigns stage_hunk<CR>", desc = "Stage Hunk" },
						{ "<leader>Gr", "<cmd>Gitsigns reset_hunk<CR>", desc = "Reset Hunk" },
						{ "<leader>Gl", diffCurrentLines, desc = "Previous Versions" },
					}

					whichkey.add(keymap_g_n)
					whichkey.add(keymap_g_v)

					-- Text object
					xnoremap("iG", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		cmd = { "DiffviewFileHistory", "DiffviewOpen" },
		event = { "VeryLazy" },
		config = function()
			local whichkey = require("which-key")
			whichkey.add(static_keymaps_diff)
			require("diffview").setup({
				hooks = {
					view_opened = function(view)
						vim.notify_once(
							("A new %s was opened on tab page %d! | Type g? to show help."):format(
								view.class:name(),
								view.tabpage
							)
						)
					end,
				},
			})
		end,
	},
}
