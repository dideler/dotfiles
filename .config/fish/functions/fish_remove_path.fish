# Fish provides a built-in `fish_add_path` function but none to remove paths.
# The definition guard is in case they add it in the future, to not overwrite.
# https://github.com/fish-shell/fish-shell/issues/8604#issuecomment-1169570520
if not functions --query fish_remove_path
  function fish_remove_path --description "Removes the given path from \$fish_user_paths or \$PATH"
    function __print_help
      echo "Usage: "(status current-command)" path ..."
      echo "Options:"
      echo "  -h, --help      Show this help message and exit"
      echo "  -v, --verbose   Verbose output"
      echo "  -n, --dry-run   Print the would-be actions without running them"
    end

    argparse h/help v/verbose n/dry-run -- $argv
    or return

    set --local argc (count $argv)

    if set --query _flag_help
    or test $argc -eq 0
      __print_help
      return 0
    end

    for path in $argv
      if set --local index (contains --index -- $path $fish_user_paths)
        if set --query _flag_dry_run
          echo "Would remove $path from \$fish_user_paths at index $index"
        else
          set --erase fish_user_paths[$index]
          and set --query _flag_verbose
          and echo "Removed $path from \$fish_user_paths at index $index"
        end
      end

      if set --local index (contains --index -- $path $PATH)
        if set --query _flag_dry_run
          echo "Would remove $path from \$PATH at index $index"
        else
          set --erase PATH[$index]
          and set --query _flag_verbose
          and echo "Removed $path from \$PATH at index $index"
        end
      end
    end
  end
end
