-- Plugin loader for kitty-aider
if vim.g.loaded_kitty_aider then
  return
end
vim.g.loaded_kitty_aider = true

-- Set up the plugin with default configuration
-- Users can call require("kitty_aider").setup({...}) to override defaults
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if not package.loaded["kitty_aider"] then
      require("kitty_aider").setup()
    end
  end,
  once = true,
})

-- Add key mappings
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local config = require("kitty_aider").config
    if config.mappings.start then
      vim.keymap.set("n", config.mappings.start, function()
        require("kitty_aider").start()
      end, { desc = "Start kitty-aider" })
    end
  end,
  once = true,
})
