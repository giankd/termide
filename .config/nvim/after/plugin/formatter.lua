local whichkey = require("which-key")
-- Utilities for creating configurations
-- local util = require "formatter.util"

-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup({
	-- Enable or disable logging
	logging = true,
	-- Set the log level
	log_level = vim.log.levels.WARN,
	-- All formatter configurations are opt-in
	filetype = {
		-- Formatter configurations for filetype
		-- will be executed in order
		lua = {
			require("formatter.filetypes.lua").stylua,
			-- You can also define your own configuration
			--[[ function()
        -- Supports conditional formatting
        if util.get_current_buffer_file_name() == "special.lua" then
          return nil
        end

        -- Full specification of configurations is down below and in Vim help
        -- files
        return {
          exe = "stylua",
          args = {
            "--search-parent-directories",
            "--stdin-filepath",
            util.escape_path(util.get_current_buffer_file_path()),
            "--",
            "-",
          },
          stdin = true,
        }
      end ]]
		},
		-- TODO PR for default?
		dart = {
			function()
				print("Formatting with dart default formatter")
				local util = require("formatter.util")
				return {
					exe = "dart",
					args = {
						"format",
						util.escape_path(util.get_current_buffer_file_path()),
					},
					stdin = true,
				}
			end,
		},
		go = {
			require("formatter.filetypes.go").gofmt,
		},
		typescript = {
			require("formatter.filetypes.typescript").prettier,
		},
		typescriptreact = {
			require("formatter.filetypes.typescriptreact").prettier,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
		javascriptreact = {
			require("formatter.filetypes.javascriptreact").prettier,
		},
		html = {
			require("formatter.filetypes.html").prettier,
		},
		svelte = {
			require("formatter.filetypes.svelte").prettier,
		},
		css = {
			require("formatter.filetypes.css").prettier,
		},
		scss = {
			require("formatter.filetypes.css").prettier,
		},
		json = {
			require("formatter.filetypes.json").fixjson,
		},
		sh = {
			require("formatter.filetypes.sh").shfmt,
		},

		-- Use the special "*" filetype for defining formatter configurations on
		-- any filetype
		["*"] = {
			-- "formatter.filetypes.any" defines default configurations for any
			-- filetype
			require("formatter.filetypes.any").remove_trailing_whitespace,
		},
	},
})

local normal_opts = {
	mode = "n", -- Normal mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
}
-- local visual_opts = {
-- 	mode = "v", -- Normal mode
-- 	prefix = "<leader>",
-- 	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
-- 	silent = true, -- use `silent` when creating keymaps
-- 	noremap = true, -- use `noremap` when creating keymaps
-- 	nowait = false, -- use `nowait` when creating keymaps
-- }

local nmappings = {
	F = {
		name = "Format",
		f = { "<Cmd>lua require('giankd.formatter').Format()<CR>", "Format File" },
		t = { "<Cmd>lua require('giankd.formatter').ToggleFormatOnSave()<CR>", "Toggle Format on Save" },
		i = { "<Cmd>lua require('giankd.formatter').GetFormatInfo()<CR>", "Format on Save Status" },
		s = { "<Cmd>lua require('giankd.formatter').SwitchFormatterType()<CR>", "Switch Formatter type" },
	},
}
-- Formatter does not support selection format
-- local vmappings = {
-- 	F = {
-- 		name = "Format",
-- 		f = { "<Cmd>lua require('giankd.formatter').FormatSelection()<CR>", "Format Selection" },
-- 	},
-- }

whichkey.register(nmappings, normal_opts)
-- whichkey.register(vmappings, visual_opts)
