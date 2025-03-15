-- Module for handling kitty-aider commands
local M = {}

-- List of available commands with descriptions
M.available_commands = {
  { name = "attach", description = "Attach to aider process (uses telescope if no id provided)" },
  { name = "send", description = "Send command to attached aider" },
  { name = "add", description = "Add current file to aider" },
  { name = "readonly", description = "Mark current file as read-only in aider" },
  { name = "drop", description = "Drop current file from aider" },
  { name = "dropall", description = "Drop all files from aider" },
  { name = "prompt", description = "Open a prompt to send text to aider" },
}

-- Display telescope picker for commands
function M.telescope_command_picker()
  local has_telescope, _ = pcall(require, "telescope.builtin")
  if not has_telescope then
    require("kitty_aider.utils").notify("Telescope is required for command picker", "error")
    return
  end

  -- Create a telescope finder
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "KittyAider Commands",
    finder = finders.new_table({
      results = M.available_commands,
      entry_maker = function(entry)
        return {
          value = entry.name,
          display = entry.name .. " - " .. entry.description,
          ordinal = entry.name,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        
        -- Execute the selected command
        local kitty_aider = require("kitty_aider")
        if selection.value == "attach" then
          kitty_aider.attach()
        elseif selection.value == "send" then
          vim.ui.input({ prompt = "Command to send: " }, function(input)
            if input then
              kitty_aider.send_command(input)
            end
          end)
        elseif selection.value == "add" then
          kitty_aider.add_current_file()
        elseif selection.value == "readonly" then
          kitty_aider.readonly_current_file()
        elseif selection.value == "drop" then
          kitty_aider.drop_current_file()
        elseif selection.value == "dropall" then
          kitty_aider.drop_all_files()
        elseif selection.value == "prompt" then
          kitty_aider.prompt()
        end
      end)
      return true
    end,
    previewer = nil,
  }):find()
end

return M
