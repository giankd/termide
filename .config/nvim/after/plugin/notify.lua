local ok, notify = pcall(require, "notify")
local utils = require("giankd.notify")
if not ok then
	utils.notify("unable to require notify")
	return
end

notify.setup({
	background_colour = "#000000",
	timeout = 2000,
	icons = {
		DEBUG = "",
		ERROR = "",
		INFO = "",
		TRACE = "✎",
		WARN = "",
	},
	stages = "slide",
})
