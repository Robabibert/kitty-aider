{ pkgs, ... }:
let
  luaInit = pkgs.writeText "init.lua" # lua
    ''
      -- Add plugin directory to runtime path
      local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
      package.path = git_root .. "/lua/?.lua;" .. git_root .. "/lua/?/init.lua;" .. package.path

      -- Print diagnostic information
      print("Loading kitty_aider from: " .. git_root)
      print("Current package.path: " .. package.path)

      -- Try to load and setup kitty_aider
      local ok, kitty_aider = pcall(require, "kitty_aider")
      if ok then
        -- Configure with test settings
        kitty_aider.setup({
          aider_cmd = ".aider-wrapped",
          debug = true,
          notify_level = "debug",
        })

        -- Test the plugin's functionality
        print("Plugin version: " .. kitty_aider.version)
        print("Successfully loaded kitty_aider")

        -- Try starting the plugin
        local start_ok, start_err = pcall(kitty_aider.start)
        if start_ok then
          print("Successfully started kitty_aider")
        else
          print("Failed to start kitty_aider: " .. tostring(start_err))
        end
      else
        print("Failed to load kitty_aider: " .. tostring(kitty_aider))
        print("Check lua/kitty_aider directory structure:")
        local handle = io.popen("ls -la " .. git_root .. "/lua/kitty_aider/")
        if handle then
          local result = handle:read("*a")
          handle:close()
          print(result)
        end
      end
    '';
  customNeovim = pkgs.neovim.override {
    configure = {
      packages.myPlugins = {
        start = with pkgs.vimPlugins; [ nvim-tree-lua neo-tree-nvim ];
      };
    };
  };
in pkgs.writers.writeFishBin "kitty-aider" # fish
''
  set GIT_ROOT (git rev-parse --show-toplevel)
  echo "Starting Neovim with kitty_aider plugin from $GIT_ROOT"
  ${customNeovim}/bin/nvim --cmd "lua vim.opt.rtp:append('$GIT_ROOT')" -u ${luaInit} $argv
''
