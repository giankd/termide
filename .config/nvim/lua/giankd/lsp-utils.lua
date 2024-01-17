local utils = require("giankd.notify")
local M = {}

M.hover = function()
	vim.lsp.buf.hover()
end

M.goto_prev_d = function()
	vim.diagnostic.goto_prev({ float = true })
end

M.goto_prev_e = function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = true })
end

M.goto_next_d = function()
	vim.diagnostic.goto_next({ float = true })
end

M.goto_next_e = function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = true })
end

M.code_actions = function()
	local has_menu, menu = pcall(require, "actions-preview")
	if has_menu then
		menu.code_actions()
	elseif vim.lsp.buf.code_action ~= nil then
		vim.lsp.buf.code_action()
	else
		utils.notify("No code action window available", { type = "error" })
	end
end

M.workspace_diagnostics = function()
	local ok = pcall(vim.cmd, "TroubleToggle workspace_diagnostics")
	if not ok then
		utils.notify("Not implemented", { type = "warn" })
	end
end

M.buf_diagnostics = function()
	local has_telescope, builtin = pcall(require, "telescope.builtin")
	if has_telescope then
		builtin.diagnostics()
		return
	end
	utils.notify("Not implemented", { type = "warn" })
end

M.line_diagnostics = function()
	utils.notify("Not implemented", { type = "warn" })
end

M.cursor_diagnostics = function()
	vim.diagnostic.open_float()
end

M.finder = function()
	local has_glance = pcall(require, "glance")
	if has_glance then
		vim.cmd("Glance references")
		return
	end

	local has_telescope, telescope = pcall(require, "telescope.builtin")
	if has_telescope then
		telescope.lsp_references({
			include_declaration = true,
			jump_type = "never",
		})
		return
	end
	vim.lsp.buf.references()
end

M.signature_help = function()
	vim.lsp.buf.signature_help()
end

M.rename = function()
	vim.lsp.buf.rename()
end

M.peek_definition = function()
	local has_glance = pcall(require, "glance")
	if has_glance then
		vim.cmd("Glance definitions")
		return
	end

	local has_telescope, telescope = pcall(require, "telescope.builtin")
	if has_telescope then
		telescope.lsp_definitions({
			jump_type = "never",
		})
		return
	end
	utils.notify("Not implemented", { type = "warn" })
end

M.goto_definition = function()
	local has_glance = pcall(require, "glance")
	if has_glance then
		vim.cmd("Glance definitions")
		return
	end

	vim.lsp.buf.definition()
end

M.goto_declaration = function()
	vim.lsp.buf.declaration()
end

M.goto_implementation = function()
	local has_glance = pcall(require, "glance")
	if has_glance then
		vim.cmd("Glance implementations")
		return
	end
	vim.lsp.buf.implementation()
end

M.goto_type_def = function()
	local has_glance = pcall(require, "glance")
	if has_glance then
		vim.cmd("Glance type_definitions")
		return
	end

	local has_telescope, telescope = pcall(require, "telescope.builtin")
	if has_telescope then
		telescope.lsp_type_definitions({
			jump_type = "never",
		})
		return
	end

	vim.lsp.buf.type_definition()
end

M.outline = function()
	local has_telescope, telescope = pcall(require, "telescope.builtin")
	if has_telescope then
		telescope.lsp_workspace_symbols()()
		return
	end

	vim.lsp.buf.workspace_symbols()
end

M.references = function()
	M.finder()
end

M.organize_imports = function()
	local cmd = { command = "_typescript.organizeImports", arguments = { vim.fn.expand("%:p") } }
	if pcall(vim.lsp.buf.execute_command, cmd) then
		utils.notify("Organized imports!", { type = "warn" })
	else
		utils.notify("Unable to organize imports!", { type = "warn" })
	end
end

return M
