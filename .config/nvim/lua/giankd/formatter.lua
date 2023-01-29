local notifier = require("giankd.notify")
local M = {}

local augroup = vim.api.nvim_create_augroup
local format_group = augroup("Format", {})

local autocmd = vim.api.nvim_create_autocmd

M.isFormatOnSaveEnabled = false
M.isNativeFormatterEnabled = false
M.canNativeFormat = false

M.Format = function()
	if M.isNativeFormatterEnabled then
		vim.lsp.buf.format()
	else
		vim.cmd("FormatLock")
	end
end

M.FormatSelection = function()
	if M.isNativeFormatterEnabled then
		vim.lsp.buf.format()
	else
		vim.cmd("FormatLock")
	end
end

M.EnableNativeFormatter = function()
	if M.isNativeFormatterEnabled then
		return
	end
	M.canNativeFormat = true
end

M.SwitchFormatterType = function()
	if not M.canNativeFormat then
		notifier.notify("No LSP native format option", { type = "error", title = "Formatter" })
		return
	end
	if M.isNativeFormatterEnabled then
		M.isNativeFormatterEnabled = false
	else
		M.isNativeFormatterEnabled = true
	end
	if M.isFormatOnSaveEnabled then
		M.ToggleFormatOnSave()
		M.ToggleFormatOnSave()
	end
end

M.EnableFormatOnSave = function()
	M.isFormatOnSaveEnabled = true
	autocmd("BufWritePost", {
		group = format_group,
		pattern = "*",
		callback = function()
			if M.isNativeFormatterEnabled then
				local ran, errorMsg = pcall(vim.lsp.buf.format, { async = true })
				if not ran then
					notifier.notify("Error in formatting file" .. errorMsg, { type = "error", title = "Formatter" })
				end
			else
				local ran, errorMsg = pcall(vim.cmd, "silent FormatWriteLock")
				if not ran then
					notifier.notify("Error in formatting file" .. errorMsg, { type = "error", title = "Formatter" })
				end
			end
		end,
	})
end

M.ToggleFormatOnSave = function()
	if not M.isFormatOnSaveEnabled then
		notifier.notify("Enabling format on save", { type = "info", title = "Formatter" })
		M.EnableFormatOnSave()
	else
		M.isFormatOnSaveEnabled = false
		notifier.notify("Disabling format on save", { type = "info", title = "Formatter" })
		vim.api.nvim_command("autocmd! Format")
	end
end

M.GetFormatInfo = function()
	local onSaveStatus = "disabled"
	local nativeStatus = "disabled"
	local nativeCap = "Cannot"

	if M.isFormatOnSaveEnabled then
		onSaveStatus = "enabled"
	end
	if M.isNativeFormatterEnabled then
		nativeStatus = "enabled"
	end
	if M.canNativeFormat then
		nativeCap = "Can"
	end
	notifier.notify(
		"Format on save: "
			.. onSaveStatus
			.. "\n"
			.. nativeCap
			.. " format with LSP"
			.. "\n"
			.. "Format with LSP: "
			.. nativeStatus,
		{ type = "info", title = "Formatter Info" }
	)
end

return M
