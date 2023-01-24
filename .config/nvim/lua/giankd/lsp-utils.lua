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
	vim.lsp.buf.code_action()
end

M.workspace_diagnostics = function()
	if vim.fn.executable("TroubleToggle") then
		vim.cmd("TroubleToggle workspace_diagnostics")
	else
		print("Not implemented")
	end
end

M.buf_diagnostics = function()
	if vim.fn.executable("TroubleToggle") then
		vim.cmd("TroubleToggle document_diagnostics")
	else
		print("Not implemented")
	end
end

M.line_diagnostics = function()
	print("Not implemented")
end

M.cursor_diagnostics = function()
	vim.diagnostic.open_float()
end

M.finder = function()
	if vim.fn.executable("TroubleToggle") then
		vim.cmd("TroubleToggle lsp_references")
	else
		vim.lsp.buf.references()
	end
end

M.signature_help = function()
	vim.lsp.buf.signature_help()
end

M.rename = function()
	vim.lsp.buf.rename()
end

M.peek_definition = function()
	if vim.fn.executable("TroubleToggle") then
		vim.cmd("TroubleToggle lsp_definitions")
	else
		print("Not implemented")
	end
end

M.goto_definition = function()
	vim.lsp.buf.definition()
end

M.goto_declaration = function()
	vim.lsp.buf.declaration()
end

M.goto_implementation = function()
	vim.lsp.buf.implementation()
end

M.goto_type_def = function()
	if vim.fn.executable("TroubleToggle") then
		vim.cmd("TroubleToggle lsp_type_definitions")
	else
		vim.lsp.buf.type_definition()
	end
end

M.outline = function()
	vim.cmd("SymbolsOutline")
end

M.references = function()
	if vim.fn.executable("Telescope") then
		vim.cmd("Telescope lsp_references")
	else
		vim.lsp.buf.references()
	end
end

M.organize_imports = function()
	local cmd = { command = "_typescript.organizeImports", arguments = { vim.fn.expand("%:p") } }
	if pcall(vim.lsp.buf.execute_command, cmd) then
		print("Organized imports!")
	else
		print("Unable to organize imports!")
	end
end

return M
