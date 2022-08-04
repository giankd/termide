require 'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "tsx",
    "toml",
    "bash",
    "php",
    "json",
    "yaml",
    "swift",
    "html",
    "scss",
    "css"
  },
  sync_install = false,

  autotag = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = {},
  },
  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },
}

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.tsx.filetype_to_parsername = { "javascript", "typescript.tsx" }
