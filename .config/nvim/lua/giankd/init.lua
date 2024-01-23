local config = require("giankd.modules.config")
local keymaps = require("giankd.modules.keymaps")
local plugins = require("giankd.modules.plugins")

local bootstrap = function()
	config.load_config()
	keymaps.bootstrap()
	plugins.bootstrap_lazy()
end

bootstrap()
