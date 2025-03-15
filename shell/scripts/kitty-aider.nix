{ pkgs, ... }:
let
  luaInit = pkgs.writeText "init.lua" # lua
    ''
      -- Try to load the plugin directly
      local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
      package.path = git_root .. "/lua/?.lua;" .. git_root .. "/lua/?/init.lua;" .. package.path

      -- Now try to load and setup kitty_aider
      local ok, kitty_aider = pcall(require, "kitty_aider")
      if ok then
        local Snacks = require("snacks")
        kitty_aider.setup({
          aider_cmd = ".aider-wrapped",
        })
        print("Successfully loaded kitty_aider")
      else
        print("Failed to load kitty_aider: " .. tostring(kitty_aider))
      end
    '';
  customNeovim = pkgs.neovim.override {
    configure = {
      packages.myPlugins = {
        start = with pkgs.vimPlugins; [
          snacks-nvim
          nvim-tree-lua
          neo-tree-nvim
        ];
      };
    };
  };
in pkgs.writers.writeFishBin "kitty-aider" # fish
''
  set GIT_ROOT (git rev-parse --show-toplevel)
  ${customNeovim}/bin/nvim --cmd "lua vim.opt.rtp:append('$GIT_ROOT')" -u ${luaInit} $argv
''
