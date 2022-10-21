local M = {}

local augroup = vim.api.nvim_create_augroup
local format_group = augroup("Format", {})

local autocmd = vim.api.nvim_create_autocmd

M.Format = function()
	vim.cmd("FormatLock")
end

M.FormatSelection = function()
	vim.cmd("FormatLock")
end

M.isFormatOnSaveEnabled = false

M.EnableFormatOnSave = function()
	M.isFormatOnSaveEnabled = true
	autocmd("BufWritePost", {
		group = format_group,
		pattern = "*",
		callback = function()
			local ran, errorMsg = pcall(vim.cmd, "silent FormatWriteLock")
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

M.GetFormatOnSaveStatus = function()
	if not M.isFormatOnSaveEnabled then
		print("Format on save disabled")
	else
		print("Format on save enabled")
	end
end

return M
