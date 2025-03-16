{ pkgs, ... }:
# Lua content for the init.lua

rec {
  kitty-aider = import ./kitty-aider.nix { inherit pkgs; };
  unit-test = import ./unit-test.nix { inherit pkgs kitty-aider; };
  bump-version = import ./bump-version.nix { inherit pkgs; };
}
