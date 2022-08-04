local M = {}

local augroup = vim.api.nvim_create_augroup
local format_group = augroup("Format", {})

local autocmd = vim.api.nvim_create_autocmd

M.isFormatOnSaveEnabled = false

M.EnableFormatOnSave = function()
	M.isFormatOnSaveEnabled = true
	autocmd("BufWritePre", {
		group = format_group,
		pattern = "*",
		callback = function()
			local ran, errorMsg = pcall(vim.cmd, "silent Neoformat")
			if not ran then
				error("Error in formatting file" .. errorMsg)
			end
		end,
	})
end

M.ToggleFormatOnSave = function()
	if not M.isFormatOnSaveEnabled then
		print("Enabling format on save")
		M.EnableFormatOnSave()
	else
		M.isFormatOnSaveEnabled = false
		print("Disabling format on save")
		vim.api.nvim_command("autocmd! Format")
	end
end

return M
