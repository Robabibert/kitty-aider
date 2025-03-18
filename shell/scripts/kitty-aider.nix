{ pkgs, ... }:
let
  luaInit = pkgs.writeText "init.lua" # lua
    ''
      -- Add plugin directory to runtime path
      local git_root = vim.fn.system("git rev-parse --show-toplevel"):gsub("\n", "")
      package.path = git_root .. "/lua/?.lua;" .. git_root .. "/lua/?/init.lua;" .. package.path

      -- Print diagnostic information

      -- Try to load and setup kitty_aider
      local ok, kitty_aider = pcall(require, "kitty_aider")
      if ok then
        -- Configure with test settings
        kitty_aider.setup({
          aider_cmd = ".aider-wrapped",
          debug = true,
          notify_level = "debug",
          integration = {
            nvim_tree = true,
          },
        })
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
        start = with pkgs.vimPlugins; [
          harpoon2
          neo-tree-nvim
          nvim-tree-lua
          telescope-nvim
        ];
      };
    };
  };
in pkgs.writers.writeFishBin "kitty-aider" # fish
''
  set GIT_ROOT (git rev-parse --show-toplevel)
  ${customNeovim}/bin/nvim --cmd "lua vim.opt.rtp:append('$GIT_ROOT')" -u ${luaInit} $argv
''
