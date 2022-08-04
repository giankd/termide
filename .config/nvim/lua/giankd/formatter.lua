local M = {}

local augroup = vim.api.nvim_create_augroup
local format_group = augroup("Format", {})

local autocmd = vim.api.nvim_create_autocmd

M.EnableFormatOnSave = function()
	autocmd("BufWritePre", {
		group = format_group,
		pattern = "*",
		callback = function()
			local ran, errorMsg = pcall(vim.cmd, "Neoformat")
			if not ran then
				error("Error in formatting file" .. errorMsg)
			end
		end,
	})
end

M.ToggleFormatOnSave = function()
	if not vim.fn.exists("#Format#BufWritePre") then
		M.EnableFormatOnSave()
	else
		autocmd("BufWritePre", {
			group = format_group,
			command = "silent!",
		})
	end
end

return M
