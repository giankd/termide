local utils = require("giankd.notify")
local M = {}

M.hover = function()
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga hover_doc")
		return
	end
	vim.lsp.buf.hover()
end

M.goto_prev_d = function()
	local has_saga_diagnostic, saga_d = pcall(require, "lspsaga.diagnostic")
	if has_saga_diagnostic then
		saga_d:goto_prev()
		return
	end
	vim.diagnostic.goto_prev({ float = true })
end

M.goto_prev_e = function()
	local has_saga_diagnostic, saga_d = pcall(require, "lspsaga.diagnostic")
	if has_saga_diagnostic then
		saga_d:goto_prev({ severity = vim.diagnostic.severity.ERROR })
		return
	end
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = true })
end

M.goto_next_d = function()
	local has_saga_diagnostic, saga_d = pcall(require, "lspsaga.diagnostic")
	if has_saga_diagnostic then
		saga_d:goto_next()
		return
	end
	vim.diagnostic.goto_next({ float = true })
end

M.goto_next_e = function()
	local has_saga_diagnostic, saga_d = pcall(require, "lspsaga.diagnostic")
	if has_saga_diagnostic then
		saga_d:goto_next({ severity = vim.diagnostic.severity.ERROR })
		return
	end
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = true })
end

M.code_actions = function()
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga code_action")
		return
	end
	local has_action_menu = pcall(vim.cmd, "CodeActionMenu")
	if not has_action_menu then
		vim.lsp.buf.code_action()
	end
end

M.workspace_diagnostics = function()
	local ok = pcall(vim.cmd, "TroubleToggle workspace_diagnostics")
	if not ok then
		utils.notify("Not implemented", { type = "warn" })
	end
end

M.buf_diagnostics = function()
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga show_buf_diagnostics")
		return
	end

	local has_telescope, builtin = pcall(require, "telescope.builtin")
	if has_telescope then
		builtin.diagnostics()
		return
	end
	utils.notify("Not implemented", { type = "warn" })
end

M.line_diagnostics = function()
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga show_line_diagnostics")
		return
	end
	utils.notify("Not implemented", { type = "warn" })
end

M.cursor_diagnostics = function()
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga show_cursor_diagnostics")
		return
	end
	vim.diagnostic.open_float()
end

M.finder = function()
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga lsp_finder")
		return
	end

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
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga rename")
		return
	end
	vim.lsp.buf.rename()
end

M.peek_definition = function()
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga peek_definition")
		return
	end
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
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga goto_definition")
		return
	end

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
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga outline")
		return
	end

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
