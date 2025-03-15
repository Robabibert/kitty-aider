-- Main module for kitty-aider plugin
local M = {}

-- Plugin version
M.version = "0.1.0"

-- Default configuration
local default_config = require("kitty_aider.config").defaults

-- Store the user's config
M.config = vim.deepcopy(default_config)

-- Initialize the plugin with user config
function M.setup(opts)
  -- Merge user config with defaults
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), opts or {})

  -- Set up any commands, autocmds, etc.
  vim.api.nvim_create_user_command("KittyAider", function(args)
    -- TODO: Implement command functionality
    print("KittyAider command called with args: " .. vim.inspect(args))
  end, {
    nargs = "?",
    desc = "Interact with kitty-aider functionality",
  })
end

-- Main function to start interaction with kitty
function M.start()
  local utils = require("kitty_aider.utils")
  -- TODO: Implement real functionality
  utils.notify("Kitty-aider started!", "info")
end

return M
