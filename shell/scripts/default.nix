{ pkgs, ... }:
# Lua content for the init.lua

rec {
  kitty-aider = import ./kitty-aider.nix { inherit pkgs; };
  tests = import ./tests.nix { inherit pkgs kitty-aider; };
}
