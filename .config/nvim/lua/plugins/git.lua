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
	G = {
		name = "Git",
		["B"] = { "<cmd>Git blame<cr>", "Blame mode (Fugitive)" },
		["l"] = { "<cmd>0GcLog<cr>", "Previous versions" },
		["m"] = { "<cmd>G mergetool<cr>", "Merge Tool" },
		["o"] = { "<cmd>Gvdiffsplit!<CR>", "Open Diff Tool" },
		["c"] = {
			name = "Conflicts",
			["k"] = { "[c", "Previous conflict" },
			["j"] = { "]c", "Next conflict" },
			["c"] = { "dp", "Put" },
			["h"] = { "<cmd>diffget //2<CR>", "Get from left" },
			["l"] = { "<cmd>diffget //3<CR>", "Get from right" },
			["s"] = { "<cmd>Gwrite!<CR>", "Resolve" },
		},
	},
}

local static_keymaps_diff = {
	["d"] = {
		name = "Diffview",
		["b"] = { "<cmd>DiffviewFileHistory<CR>", "Current Branch" },
		["f"] = { "<cmd>DiffviewFileHistory %<CR>", "Current File" },
		["d"] = { "<cmd>DiffviewOpen<CR>", "Current changes" },
		["o"] = { "<cmd>DiffviewOpen origin/main...HEAD<CR>", "Origin main" },
		["l"] = { "<cmd>DiffviewOpen HEAD~1<CR>", "Last commit" },
		["r"] = { "<cmd>DiffviewRefresh<CR>", "Refresh" },
		["c"] = { "<cmd>DiffviewClose<CR>", "Close" },
	},
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
			whichkey.register(static_keymaps_signs, { prefix = "<leader>", mode = "n", noremap = true })
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
						G = {
							name = "Git",
							["a"] = {
								function()
									gs.setqflist(0)
								end,
								"Current Buffer Changes",
							},
							["A"] = {
								function()
									gs.setqflist("all")
								end,
								"All Changes",
							},
							["S"] = { gs.stage_buffer, "Stage Buffer" },
							["R"] = { gs.reset_buffer, "Reset Buffer" },
							["u"] = { gs.undo_stage_hunk, "Unstage Hunk" },
							["P"] = { gs.preview_hunk, "Preview Hunk" },
							["p"] = { gs.preview_hunk_inline, "Preview Hunk" },
							["b"] = {
								function()
									gs.blame_line({ full = true })
								end,
								"Blame Line (Signs)",
							},
							["d"] = { gs.diffthis, "Diff" },
							["D"] = {
								function()
									gs.diffthis("~1", {
										vertical = true,
									})
								end,
								"Diff Last Commit",
							},
							["tb"] = { gs.toggle_current_line_blame, "Toggle Blame Line" },
							["td"] = { gs.toggle_deleted, "Toggle Deleted" },
							["tl"] = { gs.toggle_linehl, "Toggle Line HL" },
						},
					}

					local keymap_g_v = {
						G = {
							name = "Git",
							["s"] = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
							["r"] = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
							["l"] = { diffCurrentLines, "Previous Versions" },
						},
					}

					local wk_opts_n = { buffer = bufnr, prefix = "<leader>", mode = "n", noremap = true }
					local wk_opts_v = { buffer = bufnr, prefix = "<leader>", mode = "v", noremap = true }

					whichkey.register(keymap_g_n, wk_opts_n)
					whichkey.register(keymap_g_v, wk_opts_v)

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
			whichkey.register(static_keymaps_diff, { prefix = "<leader>", mode = "n", noremap = true })
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
