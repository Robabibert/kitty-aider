-- Basic test specs for kitty-aider
local minitest = require("minitest")
local t = minitest.new_set()

-- Load test initialization
require("minit").setup()

-- Load the plugin modules
local config = require("kitty_aider.config")
local kitty_aider = require("kitty_aider")
local utils = require("kitty_aider.utils")

-- Test plugin version
t["version"] = function()
  minitest.expect.equality(type(kitty_aider.version), "string")
  minitest.expect.equality(kitty_aider.version, "0.1.0")
end

-- Test default configuration
t["default_config"] = function()
  minitest.expect.equality(type(config.defaults), "table")
  minitest.expect.equality(config.defaults.enable_notifications, true)
  minitest.expect.equality(config.defaults.log_level, "info")
  minitest.expect.equality(type(config.defaults.mappings), "table")
end

-- Test utils module
t["utils_notify"] = function()
  -- This is a simple test that utils.notify doesn't error
  -- A more robust test would check that vim.notify was called with expected args
  minitest.expect.no_error(function()
    utils.notify("Test message")
  end)
end

-- Test configuration merging
t["setup_merges_config"] = function()
  -- Default config
  kitty_aider.setup()
  minitest.expect.equality(kitty_aider.config.log_level, "info")

  -- Custom config
  kitty_aider.setup({ log_level = "debug" })
  minitest.expect.equality(kitty_aider.config.log_level, "debug")

  -- Partial custom config doesn't affect other settings
  kitty_aider.setup({ log_level = "warn" })
  minitest.expect.equality(kitty_aider.config.enable_notifications, true)
end

return t
