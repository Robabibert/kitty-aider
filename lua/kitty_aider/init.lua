-- Main module for kitty-aider plugin
local M = {}

-- Plugin version
M.version = "0.1.0"

-- Default configuration
local default_config = {
  debug = false,
  notify_level = "info",
}

-- Store the user's config
M.config = vim.deepcopy(default_config)

-- Initialize the plugin with user config
function M.setup(opts)
  -- Merge user config with defaults
  M.config = vim.tbl_deep_extend("force", vim.deepcopy(default_config), opts or {})

  -- Set up any commands, autocmds, etc.
  vim.api.nvim_create_user_command("KittyAider", function(args)
    local cmd_args = args.fargs

    if #cmd_args == 0 then
      -- Default action: show usage
      print("Usage: KittyAider <command> [args]")
      print("Commands:")
      print("  attach [id] - Attach to aider process (uses telescope if no id provided)")
      print("  send <command> - Send command to attached aider")
      print("  add - Add current file to aider")
      print("  readonly - Mark current file as read-only in aider")
      print("  drop - Drop current file from aider")
      print("  dropall - Drop all files from aider")
      print("  prompt - Open a prompt to send text to aider")
      return
    end

    local subcmd = cmd_args[1]

    if subcmd == "attach" then
      if #cmd_args < 2 then
        -- Without an ID, use the telescope picker
        M.attach()
      else
        M.attach(cmd_args[2])
      end
    elseif subcmd == "send" then
      if #cmd_args < 2 then
        require("kitty_aider.utils").notify("Missing command. Usage: KittyAider send <command>", "error")
        return
      end
      -- Join all remaining args as the command
      local command = table.concat({ unpack(cmd_args, 2) }, " ")
      M.send_command(command)
    elseif subcmd == "add" then
      M.add_current_file()
    elseif subcmd == "readonly" then
      M.readonly_current_file()
    elseif subcmd == "drop" then
      M.drop_current_file()
    elseif subcmd == "dropall" then
      M.drop_all_files()
    elseif subcmd == "prompt" then
      M.prompt()
    else
      require("kitty_aider.utils").notify("Unknown command: " .. subcmd, "error")
    end
  end, {
    nargs = "*",
    desc = "Interact with kitty-aider functionality",
    complete = function(_, cmdline)
      local words = vim.split(cmdline, " ", { trimempty = true })

      if #words == 1 then
        -- Complete the subcommand
        return { "attach", "send", "add", "readonly", "drop", "dropall", "prompt" }
      elseif #words == 2 and words[2] == "attach" then
        -- Could offer process IDs as completion options
        local process = require("kitty_aider.process")
        local processes = process.list_aider_processes()
        local ids = {}
        for _, proc in ipairs(processes) do
          table.insert(ids, proc.id)
        end
        return ids
      end

      return {}
    end,
  })
end

-- Function to attach to an aider process
function M.attach(process_id)
  local process = require("kitty_aider.process")

  if process_id then
    return process.attach(process_id)
  else
    -- If no ID provided, use the telescope picker
    return process.telescope_picker()
  end
end

-- Function to send command to attached aider process
function M.send_command(command)
  local process = require("kitty_aider.process")
  return process.send_command(command)
end

-- File operations
function M.add_current_file()
  return require("kitty_aider.files").add_current_file()
end

function M.readonly_current_file()
  return require("kitty_aider.files").readonly_current_file()
end

function M.drop_current_file()
  return require("kitty_aider.files").drop_current_file()
end

function M.drop_all_files()
  return require("kitty_aider.files").drop_all_files()
end

-- Function to prompt for text and send it to aider
function M.prompt()
  vim.ui.input({ prompt = "Aider prompt: " }, function(input)
    if input then
      -- Send the text directly (not as a command)
      require("kitty_aider.process").send_command(input)
    end
  end)
end

return M
