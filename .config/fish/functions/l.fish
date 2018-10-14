function __l_print_help
    printf "Usage: l [FILE_COUNT]\n\n"
    printf "Description:\n"
    printf "    Prints recently modified files\n\n"
    printf "Examples:\n"
    printf "  l                    # Last few files in current directory\n"
    printf "  l -n 5               # Last 5 files in current directory\n"
    printf "  l ~/Music            # Last few files in another directory\n"
    printf "  l ~/Music --count 5  # Last 5 files in another directory\n\n"
    printf "Options:\n"
    printf "   -h, --help   Prints help and exits\n"
    printf "   -n, --count  Limits file count (minimum 1)"
end

function l --description "Show last n files by newest to oldest"
  set --local options 'h/help' 'n/count=!_validate_int --min 1'
  argparse $options -- $argv

  if set --query _flag_help
    __l_print_help
    return 0
  end

  set --query _flag_count; or set --local _flag_count 10

  if test -d $argv[1]
    ls -t $argv[1] | head -n $_flag_count
  else
    ls -t | head -n $_flag_count
  end
end
