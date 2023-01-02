local Remap = require("giankd.keymap")
local nnoremap = Remap.nnoremap
local nmap = Remap.nmap
local vnoremap = Remap.vnoremap
local xnoremap = Remap.xnoremap

require("gitsigns").setup({
	signs = {
		add = {
			hl = "GitSignsAdd",
			text = "│",
			numhl = "GitSignsAddNr",
			linehl = "GitSignsAddLn",
			show_count = true,
		},
		change = {
			hl = "GitSignsChange",
			text = "│",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
			show_count = true,
		},
		delete = {
			hl = "GitSignsDelete",
			text = "_",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
			show_count = true,
		},
		topdelete = {
			hl = "GitSignsDelete",
			text = "‾",
			numhl = "GitSignsDeleteNr",
			linehl = "GitSignsDeleteLn",
			show_count = true,
		},
		changedelete = {
			hl = "GitSignsChange",
			text = "~",
			numhl = "GitSignsChangeNr",
			linehl = "GitSignsChangeLn",
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
	attach_to_untracked = true,
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
	yadm = {
		enable = false,
	},
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

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
		local whichkey = require("which-key")
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
				["s"] = { "<cmd>Gitsigns stage_hunk<CR>", "Stage Hunk" },
				["S"] = { gs.stage_buffer, "Stage Buffer" },
				["r"] = { "<cmd>Gitsigns reset_hunk<CR>", "Reset Hunk" },
				["R"] = { gs.reset_buffer, "Reset Buffer" },
				["u"] = { gs.undo_stage_hunk, "Unstage Hunk" },
				["p"] = { gs.preview_hunk, "Preview Hunk" },
				["b"] = {
					function()
						gs.blame_line({ full = true })
					end,
					"Blame Line (Signs)",
				},
				["B"] = { "<cmd>Git blame<cr>", "Blame mode (Fugitive)" },
				["l"] = { "<cmd>0GcLog<cr>", "Previous versions of current file" },
				["d"] = { gs.diffthis, "Diff" },
				["D"] = {
					function()
						gs.diffthis("~", {
							vertical = true,
						})
					end,
					"Diff All",
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
				["l"] = { "<cmd>GcLog<CR>", "Previous Versions" },
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
