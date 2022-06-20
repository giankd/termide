nnoremap <silent> \\ <cmd>Telescope buffers<cr>

lua << EOF
function telescope_buffer_dir()
  return vim.fn.expand('%:p:h')
end

local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup{
  defaults = {
    file_ignore_patterns = { "node_modules", ".git", ".yarn", "vendor" },
    mappings = {
      i = {
          ["<C-j>"] = actions.move_selection_next,
          ["<C-k>"] = actions.move_selection_previous,
          ["<C-n>"] = actions.cycle_history_next,
          ["<C-p>"] = actions.cycle_history_prev,
        },
      n = {
        ["q"] = actions.close
      },
      extensions = {
          -- TODO: Octo https://github.com/pwntester/octo.nvim
        }
    },
  }
}
EOF
