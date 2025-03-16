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
  ];

  shellHook = ''
    exec fish;
  '';
}
