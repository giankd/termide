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
		saga_d:goto_prev({ severity = vim.diagnostic.severity.WARN })
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
		saga_d:goto_next({ severity = vim.diagnostic.severity.WARN })
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
	vim.lsp.buf.code_action()
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

	local ok, builtin = pcall(require, "telescope.builtin")
	if not ok then
		utils.notify("Not implemented", { type = "warn" })
		return
	end
	builtin.diagnostics()
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

	local ok, telescope = pcall(require, "telescope.builtin")
	if not ok then
		vim.lsp.buf.references()
		return
	end
	telescope.lsp_references({
		include_declaration = true,
		jump_type = "never",
	})
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
	local ok, telescope = pcall(require, "telescope.builtin")
	if not ok then
		utils.notify("Not implemented", { type = "warn" })
		return
	end
	telescope.lsp_definitions({
		jump_type = "never",
	})
end

M.goto_definition = function()
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga goto_definition")
		return
	end
	vim.lsp.buf.definition()
end

M.goto_declaration = function()
	vim.lsp.buf.declaration()
end

M.goto_implementation = function()
	vim.lsp.buf.implementation()
end

M.goto_type_def = function()
	local ok, telescope = pcall(require, "telescope.builtin")
	if not ok then
		vim.lsp.buf.type_definition()
		return
	end
	telescope.lsp_type_definitions({
		jump_type = "never",
	})
end

M.outline = function()
	local has_saga = pcall(require, "lspsaga")
	if has_saga then
		vim.cmd("Lspsaga outline")
		return
	end

	local ok = pcall(vim.cmd, "SymbolsOutline")
	if not ok then
		vim.lsp.buf.workspace_symbols()
	end
end

M.references = function()
	local ok, telescope = pcall(require, "telescope.builtin")
	if not ok then
		vim.lsp.buf.references()
		return
	end
	telescope.lsp_references({
		include_declaration = true,
		jump_type = "never",
	})
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
