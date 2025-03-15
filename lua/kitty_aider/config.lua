-- Configuration for kitty-aider
local M = {}

-- Default configuration options
M.defaults = {
  -- Kitty socket path, nil means use default
  kitty_socket = nil,

  -- Default options
  enable_notifications = true,
  log_level = "info", -- debug, info, warn, error

  -- Key mappings
  mappings = {
    start = "<leader>ka",
  },
}

return M
