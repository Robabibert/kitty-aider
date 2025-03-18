-- Test file for kitty_aider commands
local commands = require("kitty_aider.commands")
local kitty_aider = require("kitty_aider")

describe("kitty_aider commands", function()
  -- Test that all commands are properly defined
  it("should have all expected commands available", function()
    local expected_commands = {
      "attach",
      "send",
      "add",
      "readonly",
      "drop",
      "dropall",
      "prompt",
    }

    -- Check that each expected command exists in available_commands
    for _, cmd_name in ipairs(expected_commands) do
      local found = false
      for _, cmd in ipairs(commands.available_commands) do
        if cmd.name == cmd_name then
          found = true
          break
        end
      end
      assert.is_true(found, "Command '" .. cmd_name .. "' should be available")
    end
  end)

  -- Test that each command has a description
  it("should have descriptions for all commands", function()
    for _, cmd in ipairs(commands.available_commands) do
      assert.is_string(cmd.description)
      assert.is_true(#cmd.description > 0, "Command '" .. cmd.name .. "' should have a non-empty description")
    end
  end)

  -- Test that the command functions exist in the kitty_aider module
  it("should have all command functions in the kitty_aider module", function()
    -- Map of command names to function names in the kitty_aider module
    local cmd_to_func = {
      attach = "attach",
      send = "send_command",
      add = "add_current_file",
      readonly = "readonly_current_file",
      drop = "drop_current_file",
      dropall = "drop_all_files",
      prompt = "prompt",
    }

    for cmd_name, func_name in pairs(cmd_to_func) do
      assert.is_function(
        kitty_aider[func_name],
        "Function '" .. func_name .. "' should exist for command '" .. cmd_name .. "'"
      )
    end
  end)

  -- Test that the telescope command picker function exists
  it("should have a telescope command picker function", function()
    assert.is_function(commands.telescope_command_picker)
  end)
end)
