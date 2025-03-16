{ pkgs, ... }:
pkgs.writers.writeFishBin "init-fish" # fish
''
  function print_welcome_message
    # Print welcome message with available commands
    set_color green
    echo "Available development commands:"
    set_color normal
    
    # Development
    set_color yellow
    echo "  Development:"
    set_color normal
    echo "    kitty-aider            - Run isolated nvim with plugin enabled"

    # Testing
    set_color yellow
    echo "  Testing:"
    set_color normal
    echo "    unit-test              - Run project unit tests"
    
    # Deployment
    set_color yellow
    echo "  Deployment:"
    set_color normal
    echo "    git bump               - Bump version and update changelog"
    echo
  end


  function __init_completions
  end

  __init_completions
  print_welcome_message
''

