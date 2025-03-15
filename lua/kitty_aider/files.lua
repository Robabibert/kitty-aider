-- Module for file operations with aider
local M = {}

local process = require("kitty_aider.process")
local utils = require("kitty_aider.utils")

-- Helper function to check prerequisites before performing file operations
local function check_prerequisites()
  if not process.is_attached() then
    utils.notify("No aider process attached. Use :KittyAider attach first.", "error")
    return false
  end

  local current_file = vim.fn.expand("%:p")
  if current_file == "" then
    utils.notify("No file is currently open", "error")
    return false
  end

  return current_file
end

-- Add the current file to aider
function M.add_current_file()
  local current_file = check_prerequisites()
  if not current_file then
    return false
  end

  return process.send_command("/add " .. current_file)
end

-- Mark the current file as read-only in aider
function M.readonly_current_file()
  local current_file = check_prerequisites()
  if not current_file then
    return false
  end

  return process.send_command("/read-only " .. current_file)
end

-- Drop the current file from aider
function M.drop_current_file()
  local current_file = check_prerequisites()
  if not current_file then
    return false
  end

  return process.send_command("/drop " .. current_file)
end

-- Drop all files from aider
function M.drop_all_files()
  if not process.is_attached() then
    utils.notify("No aider process attached. Use :KittyAider attach first.", "error")
    return false
  end

  return process.send_command("/drop")
end

-- Add a file to aider by path
function M.add_file_by_path(file_path)
  if not process.is_attached() then
    utils.notify("No aider process attached. Use :KittyAider attach first.", "error")
    return false
  end

  if not file_path or file_path == "" then
    utils.notify("No file path provided", "error")
    return false
  end

  return process.send_command("/add " .. file_path)
end

return M
