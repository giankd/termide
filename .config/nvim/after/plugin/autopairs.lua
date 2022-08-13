local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
	return
end

npairs.setup({
	disable_filetype = { "TelescopePrompt" },
	disable_in_macro = true,
	enable_check_bracket_line = false,
	check_ts = true,
})
