local ok, lspcolors = pcall(require, "lsp-colors")
if not ok then
	print("unable to require lspcolors")
	return
end

lspcolors.setup({
	Error = "#db4b4b",
	Warning = "#e0af68",
	Information = "#0db9d7",
	Hint = "#10B981",
})
