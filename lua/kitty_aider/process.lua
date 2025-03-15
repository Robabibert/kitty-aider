-- Module for handling kitty process interaction
local M = {}

local utils = require("kitty_aider.utils")

-- Store the currently attached process info
M.current_process = nil

-- List all available aider processes running in kitty windows
function M.list_aider_processes()
  -- Use kitty's remote control to list windows
  local output = vim.fn.system("kitty @ ls")

  if vim.v.shell_error ~= 0 then
    utils.notify("Failed to list kitty windows. Is kitty running?", "error")
    return {}
  end

  local processes = {}
  local kitty_data = vim.fn.json_decode(output)

  -- Parse output to find windows running aider
  for _, os_window in ipairs(kitty_data) do
    for _, tab in ipairs(os_window.tabs) do
      for _, window in ipairs(tab.windows) do
        -- Check if this looks like an aider window
        if window.last_reported_cmdline and window.last_reported_cmdline:match("^aider") then
          table.insert(processes, {
            id = window.id,
            title = window.title,
            os_window_id = os_window.id,
            tab_id = tab.id,
          })
        end
      end
    end
  end

  return processes
end

-- Attach to an aider process
function M.attach(process_id)
  local processes = M.list_aider_processes()

  -- Find the process with the matching ID
  local found_process = nil
  for _, process in ipairs(processes) do
    if process.id == process_id then
      found_process = process
      break
    end
  end

  if not found_process then
    utils.notify("No aider process found with ID: " .. process_id, "error")
    return false
  end

  -- Store the current process
  M.current_process = found_process
  utils.notify("Attached to aider process: " .. found_process.title, "info")
  return true
end

-- Send a command to the attached aider process
function M.send_command(command)
  if not M.current_process then
    utils.notify("No aider process attached. Use :KittyAider attach first.", "error")
    return false
  end

  -- Prepare the command to send text to the kitty window
  local kitty_cmd =
    string.format("kitty @ send-text --match id:%s %s", M.current_process.id, vim.fn.shellescape(command .. "\r"))

  local result = vim.fn.system(kitty_cmd)

  if vim.v.shell_error ~= 0 then
    utils.notify("Failed to send command to aider: " .. result, "error")
    return false
  end

  return true
end

-- Check if attached to an aider process
function M.is_attached()
  return M.current_process ~= nil
end

-- Add a Telescope picker for aider processes
function M.telescope_picker()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    utils.notify("Telescope plugin is required for this feature", "error")
    return
  end

  local processes = M.list_aider_processes()
  if #processes == 0 then
    utils.notify("No aider processes found in kitty terminal", "warn")
    return
  end

  local items = {}
  for _, proc in ipairs(processes) do
    table.insert(items, {
      id = proc.id,
      title = proc.title,
      display = string.format("[ID: %s] %s", proc.id, proc.title),
    })
  end

  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Aider Processes",
      finder = finders.new_table({
        results = items,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.display,
            ordinal = entry.display,
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          actions.close(prompt_bufnr)

          -- Attach to the selected process
          if selection and selection.value then
            M.attach(selection.value.id)
          end
        end)
        return true
      end,
    })
    :find()
end

-- Try to automatically attach to an aider process
function M.ensure_attached(callback)
  -- If already attached, just run the callback
  if M.is_attached() then
    if callback then callback() end
    return true
  end

  local processes = M.list_aider_processes()
  
  if #processes == 0 then
    utils.notify("No aider processes found in kitty terminal", "warn")
    return false
  elseif #processes == 1 then
    -- If there's only one process, attach to it automatically
    if M.attach(processes[1].id) and callback then
      callback()
      return true
    end
  else
    -- If there are multiple processes, use the picker
    -- We need to modify the picker to run the callback after selection
    local pickers = require("telescope.pickers")
    local finders = require("telescope.finders")
    local conf = require("telescope.config").values
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    local items = {}
    for _, proc in ipairs(processes) do
      table.insert(items, {
        id = proc.id,
        title = proc.title,
        display = string.format("[ID: %s] %s", proc.id, proc.title),
      })
    end

    pickers
      .new({}, {
        prompt_title = "Aider Processes",
        finder = finders.new_table({
          results = items,
          entry_maker = function(entry)
            return {
              value = entry,
              display = entry.display,
              ordinal = entry.display,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            local selection = action_state.get_selected_entry()
            actions.close(prompt_bufnr)

            -- Attach to the selected process
            if selection and selection.value then
              if M.attach(selection.value.id) and callback then
                callback()
              end
            end
          end)
          return true
        end,
      })
      :find()
  end
  
  return false
end

return M
