{ pkgs, kitty-aider, ... }:
pkgs.writers.writeFishBin "tests" # fish
''
  set GIT_ROOT (git rev-parse --show-toplevel)
  exec ${kitty-aider}/bin/kitty-aider -l $GIT_ROOT/tests/minit.lua --minitest
''
