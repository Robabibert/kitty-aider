-- Utility functions for kitty-aider
local M = {}

-- Send a notification to the user
function M.notify(msg, level)
  level = level or "info"
  vim.notify("[kitty-aider] " .. msg, vim.log.levels[string.upper(level)], { title = "Kitty Aider" })
end

-- Execute a kitty remote control command
function M.kitty_command(cmd, callback)
  -- This is a placeholder for actual kitty remote control implementation
  -- You'll need to use vim.fn.jobstart or similar to communicate with kitty

  -- Mock implementation for now
  vim.defer_fn(function()
    callback({ success = true, output = "Mock kitty command: " .. cmd })
  end, 100)
end

-- Get the path to the kitty socket
function M.get_kitty_socket()
  local config = require("kitty_aider").config

  if config.kitty_socket then
    return config.kitty_socket
  end

  -- Try to auto-detect kitty socket
  -- This is just a placeholder - implement the actual detection logic
  return os.getenv("KITTY_LISTEN_ON")
end

return M
