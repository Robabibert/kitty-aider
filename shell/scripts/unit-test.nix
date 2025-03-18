{ pkgs, kitty-aider, ... }:
pkgs.writers.writeFishBin "unit-test" # fish
''
  set GIT_ROOT (git rev-parse --show-toplevel)
  ${kitty-aider}/bin/kitty-aider -l "$GIT_ROOT/tests/minit.lua" --minitest
''
