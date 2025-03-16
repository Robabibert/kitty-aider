{ pkgs, ... }:
pkgs.writers.writeFishBin "utils" # fish
''
  function print_error
    set_color red
    echo "ERROR: $argv" >&2
    set_color normal
  end

  function print_success
    set_color green
    echo "✓ $argv"
    set_color normal
  end

  function print_info
    set_color blue
    echo "→ $argv"
    set_color normal
  end

  function ensure_git_clean
    if not git diff-index --quiet HEAD --
      print_error "Git working tree is dirty. Please commit or stash your changes first."
      exit 1
    end
  end
''

