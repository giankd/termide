local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

M.buffers = function(opts)
	opts = opts or {}
	opts.attach_mappings = function(prompt_bufnr, map)
		local delete_buf = function()
			local selection = action_state.get_selected_entry()
			actions.close(prompt_bufnr)
			vim.api.nvim_buf_delete(selection.bufnr, { force = true })
		end
		map("i", "<c-x>", delete_buf)
		return true
	end
	opts.previewer = false
	opts.show_all_buffers = true
	opts.sort_lastused = true
	opts.shorten_path = false
	require("telescope.builtin").buffers(require("telescope.themes").get_dropdown(opts))
end

return M
