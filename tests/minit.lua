-- Minimal initialization for tests
local M = {}

-- Set up minimal Neovim environment for testing
function M.setup()
  -- Add project's lua/ directory to package path
  local project_root = vim.fn.fnamemodify(vim.fn.getcwd(), ":p")
  package.path = project_root .. "lua/?.lua;" .. package.path

  -- Create minimal vim global to simulate Neovim environment
  _G.vim = _G.vim or {}
  vim.api = vim.api or {}
  vim.fn = vim.fn or {}
  vim.notify = vim.notify or function(msg)
    print(msg)
  end
  vim.log = vim.log or { levels = { ERROR = 1, WARN = 2, INFO = 3, DEBUG = 4 } }

  -- Mock some common Neovim API functions
  vim.api.nvim_create_user_command = function(name, fn, opts) end
  vim.api.nvim_create_autocmd = function(event, opts) end
  vim.keymap = vim.keymap or { set = function() end }
  vim.tbl_deep_extend = function(behavior, ...)
    local result = {}
    for i = 1, select("#", ...) do
      local tbl = select(i, ...)
      for k, v in pairs(tbl) do
        result[k] = v
      end
    end
    return result
  end
  vim.deepcopy = function(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
        copy[vim.deepcopy(orig_key)] = vim.deepcopy(orig_value)
      end
    else
      copy = orig
    end
    return copy
  end
end

return M
