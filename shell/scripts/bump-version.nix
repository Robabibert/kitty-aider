{ pkgs, ... }:
let
  utils = import ./utils.nix { inherit pkgs; };
  # Run tests before deployment
in pkgs.writers.writeFish "bump-semantic-version" { } # fish
''
  source ${utils}/bin/utils
  # Parse arguments
  argparse 'h/help' -- $argv

  # Show help if requested
  if set -q _flag_help
    echo "Usage: bump-semantic-version [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help        Show this help message"
    echo "  -d, --deploy-prod Deploy to production after tagging"
    exit 0
  end


  ensure_git_clean

  set GIT_ROOT (git rev-parse --show-toplevel)
  set NEW_VERSION (${pkgs.git-cliff}/bin/git-cliff --bumped-version --repository $GIT_ROOT|sed "s/v//")
  set CHANGELOG "$GIT_ROOT/CHANGELOG.md"


  # Update changelog
  ${pkgs.git-cliff}/bin/git-cliff --bump --output $CHANGELOG --repository $GIT_ROOT

  # Commit changes
  git add $CHANGELOG 
  git commit -m "chore: update changelog and version for v$NEW_VERSION"
  git tag -a "v$NEW_VERSION" -m "Release $NEW_VERSION"
  print_success "Tagged v$NEW_VERSION"
''

