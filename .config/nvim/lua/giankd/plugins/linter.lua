local ok, lint = pcall(require, "lint")
local utils = require("giankd.notify")
local M = {}
local noop = function() end
M.config = noop

if not ok then
	utils.notify("Unable to require lint")
	return M
end

M.config = function()
	require("lint").linters_by_ft = {
		markdown = { "vale" },
		javascript = { "eslint_d" },
		javascriptreact = { "eslint_d" },
		typescript = { "eslint_d" },
		typescriptreact = { "eslint_d" },
	}
	vim.api.nvim_create_autocmd({ "BufWritePost" }, {
		callback = function()
			require("lint").try_lint()
		end,
	})
end

return M
