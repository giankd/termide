vim.api.nvim_create_user_command("Debug", function()
	vim.notify("Debug initialized")
end, { desc = "Initialize Debug" })

-- Get configs and names from https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
local configs = {
	javascript = {
		{
			name = "Launch",
			type = "node2",
			request = "launch",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
		},
		-- {
		-- 	-- For this to work you need to make sure the node process is started with the `--inspect` flag.
		-- 	name = "Attach to process",
		-- 	type = "node2",
		-- 	request = "attach",
		-- 	processId = require("dap.utils").pick_process,
		-- },
		{
			name = "Debug Chrome",
			type = "chrome",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = "/usr/bin/firefox",
		},
	},
	typescript = {
		{
			type = "node2",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			sourceMaps = true,
			protocol = "inspector",
			console = "integratedTerminal",
			cwd = vim.fn.getcwd(),
		},
		{
			name = "Debug Chrome",
			type = "chrome",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = "/usr/bin/firefox",
		},
	},
	javascriptreact = {
		{
			name = "Debug Chrome",
			type = "chrome",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = "/usr/bin/firefox",
		},
	},
	typescriptreact = {
		{
			name = "Debug Chrome",
			type = "chrome",
			request = "attach",
			program = "${file}",
			cwd = vim.fn.getcwd(),
			sourceMaps = true,
			protocol = "inspector",
			port = 9222,
			webRoot = "${workspaceFolder}",
		},
		{
			name = "Debug with Firefox",
			type = "firefox",
			request = "launch",
			reAttach = true,
			url = "http://localhost:3000",
			webRoot = "${workspaceFolder}",
			firefoxExecutable = "/usr/bin/firefox",
		},
	},
}

return {
	{
		"mfussenegger/nvim-dap",
		cmd = { "Debug" },
		dependencies = {
			"leoluz/nvim-dap-go",
			"rcarriga/nvim-dap-ui",
			"theHamsta/nvim-dap-virtual-text",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
			"jay-babu/mason-nvim-dap.nvim",
			"folke/which-key.nvim",
		},
		config = function()
			local dap = require("dap")
			local ui = require("dapui")

			require("dapui").setup()
			require("dap-go").setup()
			require("mason-nvim-dap").setup({
				ensure_installed = {
					"delve",
					"node2",
					"chrome",
					"firefox",
					"php", -- https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation#php
				},
				handlers = {
					function(config)
						require("mason-nvim-dap").default_setup(config)
					end,
				},
			})

			require("nvim-dap-virtual-text").setup({
				-- This just tries to mitigate the chance that I leak tokens here. Probably won't stop it from happening...
				display_callback = function(variable)
					local name = string.lower(variable.name)
					local value = string.lower(variable.value)
					if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
						return "*****"
					end

					if #variable.value > 15 then
						return " " .. string.sub(variable.value, 1, 15) .. "... "
					end

					return " " .. variable.value
				end,
			})

			for config_name, config in pairs(configs) do
				dap.configurations[config_name] = config
			end

			local whichkey = require("which-key")

			whichkey.register({
				D = {
					name = "Debug",
					["b"] = {
						function()
							dap.toggle_breakpoint()
						end,
						"Toggle breakpoint",
					},
					["g"] = {
						function()
							dap.run_to_cursor()
						end,
						"Vai al cursore",
					},
					["?"] = {
						function()
							require("dapui").eval(nil, { enter = true })
						end,
						"Eval under cursor",
					},
					["c"] = {
						function()
							dap.continue()
						end,
						"Continue",
					},
					["i"] = {
						function()
							dap.step_into()
						end,
						"Into",
					},
					["o"] = {
						function()
							dap.step_over()
						end,
						"Over",
					},
					["O"] = {
						function()
							dap.step_out()
						end,
						"Out",
					},
					["B"] = {
						function()
							dap.step_back()
						end,
						"Back",
					},
					["R"] = {
						function()
							dap.restart()
						end,
						"Restart",
					},
					["q"] = {
						function()
							dap.terminate()
						end,
						"Restart",
					},
				},
			}, { prefix = "<leader>", mode = "n", noremap = true })

			dap.listeners.before.attach.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				ui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				ui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				ui.close()
			end
		end,
	},
}
