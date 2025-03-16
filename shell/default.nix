{ pkgs, ... }:
let scripts = import ./scripts { inherit pkgs; };
in pkgs.mkShell {
  buildInputs = with pkgs; [
    # Core
    neovim
    lua
    luajit
    luarocks

    # Lua development tools
    stylua # Formatter

    # Testing
    nodejs # For some test runners

    scripts.kitty-aider
    scripts.unit-test
    git-cliff
  ];

    exec fish;
  shellHook = # bash
      git config --global alias.cliff git-cliff
      git config --global alias.bump !${scripts.bump-version}
    '';
}
