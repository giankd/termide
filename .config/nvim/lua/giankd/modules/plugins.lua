local M = {}

M.bootstrap_lazy = function()
	local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)

	local ok, lazy = pcall(require, "lazy")

	if not ok then
		print("Unable to find a lazy installation!")
		return
	end

	local options = {
		-- spec = {
		--	{ import = "plugins" },
		-- },
		defaults = { lazy = true },
		-- install = { colorscheme = { "tokyonight", "habamax" } },
		checker = { enabled = true },
		diff = {
			cmd = "terminal_git",
		},
		performance = {
			cache = {
				enabled = true,
				-- disable_events = {},
			},
		},
		ui = {},
		debug = false,
	}

	lazy.setup({ { import = "plugins" }, { import = "plugins.lsp" } }, options)
end

return M
