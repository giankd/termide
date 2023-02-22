require("giankd.set")
require("giankd.packer")
require("giankd.debugger")

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

-- TODO Rust things
-- autocmd({ "BufEnter", "BufWinEnter", "TabEnter" }, {
--   group = GiankdGroup,
--   pattern = "*.rs",
--   callback = function()
--     require("lsp_extensions").inlay_hints {}
--   end
-- })

autocmd({ "BufWritePre" }, {
	group = GiankdGroup,
	pattern = "*",
	command = "%s/\\s\\+$//e",
})
