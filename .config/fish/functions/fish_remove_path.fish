# Fish provides a built-in `fish_add_path` function but none to remove paths.
# https://github.com/fish-shell/fish-shell/issues/8604#issuecomment-1169570520
function fish_remove_path --description "Removes the given path from \$fish_user_paths or \$PATH"
  function __print_help
    echo "Usage: "(status current-command)" path ..."
    echo "Options:"
    echo "  -h, --help      Show this help message and exit"
    echo "  -v, --verbose   Verbose output"
  end

  argparse h/help v/verbose -- $argv
  or return

  set --local argc (count $argv)

  if set --query _flag_help
  or test $argc -eq 0
    __print_help
    return 0
  end

  for path in $argv
    set --local index (contains --index -- $path $fish_user_paths)
    and set --erase fish_user_paths[$index]
    and set --query _flag_verbose
    and echo "Removed $path from \$fish_user_paths at index $index"

    set --local index (contains --index -- $path $PATH)
    and set --erase PATH[$index]
    and set --query _flag_verbose
    and echo "Removed $path from \$PATH at index $index"
  end
end
