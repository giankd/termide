local M = {}

M.config = function()
	require("actions-preview").setup({
		backend = { "telescope" },
		-- options related to telescope.nvim
		telescope = vim.tbl_extend(
			"force",
			require("telescope.themes").get_cursor(),
			-- a table for customizing content
			{
				-- a function to make a table containing the values to be displayed.
				-- fun(action: Action): { title: string, client_name: string|nil }
				-- make_value = nil,

				-- a function to make a function to be used in `display` of a entry.
				-- see also `:h telescope.make_entry` and `:h telescope.pickers.entry_display`.
				-- fun(values: { index: integer, action: Action, title: string, client_name: string }[]): function
				-- make_make_display = nil,
			}
		),
	})
end

return M
