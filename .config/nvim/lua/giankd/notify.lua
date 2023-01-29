local M = {}

local default_options = {
	type = "info",
	title = "Message",
}

local log_level_map = {
	error = vim.log.levels.ERROR,
	warn = vim.log.levels.WARN,
	info = vim.log.levels.INFO,
}
local function map_vim_log_levels(level)
	return log_level_map[level] or vim.log.levels.INFO
end

M.notify = function(message, opts)
	local _opts = opts or default_options

	local is_plugin_available, n = pcall(require, "notify")
	if not is_plugin_available then
		local level = map_vim_log_levels(_opts.type)
		vim.notify(message, level)
		return
	end

	n(message, _opts.type, _opts)
end

return M
