local M = {}

local load_default_groups = function()
	local augroup = vim.api.nvim_create_augroup
	GiankdGroup = augroup("Giankd", {})

	local autocmd = vim.api.nvim_create_autocmd
	local yank_group = augroup("HighlightYank", {})

	autocmd("TextYankPost", {
		group = yank_group,
		pattern = "*",
		callback = function()
			vim.highlight.on_yank({
				higroup = "IncSearch",
				timeout = 40,
			})
		end,
	})

	autocmd({ "BufWritePre" }, {
		group = GiankdGroup,
		pattern = "*",
		command = "%s/\\s\\+$//e",
	})

	autocmd({ "VimEnter" }, {
		group = GiankdGroup,
		pattern = "*",
		command = "tabdo windo clearjumps",
	})
end

local load_default_config = function()
	vim.opt.nu = true
	vim.opt.relativenumber = true

	vim.opt.errorbells = false

	vim.opt.tabstop = 4
	vim.opt.softtabstop = 4
	vim.opt.shiftwidth = 4
	vim.opt.expandtab = true

	vim.opt.smartindent = true
	vim.opt.autoindent = true

	vim.opt.wrap = false

	vim.opt.swapfile = false
	vim.opt.backup = false
	vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
	vim.opt.undofile = true

	vim.opt.clipboard = "unnamedplus"

	vim.opt.ignorecase = true
	vim.opt.smartcase = true
	vim.opt.hlsearch = true
	vim.opt.incsearch = true

	vim.opt.termguicolors = true

	vim.opt.scrolloff = 8
	vim.opt.signcolumn = "yes"

	-- Give more space for displaying messages.
	vim.opt.cmdheight = 2

	-- Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
	-- delays and poor user experience.
	vim.opt.updatetime = 150

	-- File navigation
	vim.g.netrw_browse_split = 0
	vim.g.netrw_banner = 0
	vim.g.netrw_winsize = 35
	vim.g.netrw_list_hide = 0

	vim.g.mapleader = " "

	-- Do not load tohtml.vim
	vim.g.loaded_2html_plugin = 1

	-- Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all these plugins are
	-- related to checking files inside compressed files)
	vim.g.loaded_zipPlugin = 1
	vim.g.loaded_gzip = 1
	vim.g.loaded_tarPlugin = 1

	-- Do not load the tutor plugin
	vim.g.loaded_tutor_mode_plugin = 1

	-- Do not use builtin matchit.vim and matchparen.vim since we use vim-matchup
	vim.g.loaded_matchit = 1
	vim.g.loaded_matchparen = 1

	-- Disable sql omni completion, it is broken.
	vim.g.loaded_sql_completion = 1
end

M.load_config = function()
	load_default_config()
	load_default_groups()
end

return M
