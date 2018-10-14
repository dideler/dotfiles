function __l_print_help
    printf "Usage: l [FILE_COUNT]\n\n"
    printf "Examples:\n"
    printf "  l   # Last 10 modified files in the current directory\n"
    printf "  l 5 # Last 5 modified files in the current directory\n"
end

function l --description "Show last n files by newest to oldest"
  set --local options 'h/help'
  argparse $options -- $argv

  if set --query _flag_help
    __l_print_help
    return 0
  end

  if test (count $argv) -eq 1
    ls -t | head -n $argv[1]
  else
    ls -t | head
  end
end
