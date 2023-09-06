function extension -d "Returns the extension given a filepath"
  function __help
    echo "Returns the probable extension from a given filepath, e.g. 'file.txt' => 'txt'

Usage: "(status current-command)" [options] [file]

Options:
  -h, --help    Show this help message and exit
  -m, --multi   Extract multiple extensions, e.g. 'file.tar.gz' => 'tar.gz'
  -l, --lower   Returns the extension in lowercase
  -u, --upper   Returns the extension in uppercase"
  end

  set --local options 'h/help' 'm/multi' 'l/lower' 'u/upper'
  argparse --max-args=1 $options -- $argv
  or return

  set --local argc (count $argv)

  if set --query _flag_help
  or test $argc -eq 0
    __help
    return 0
  end

  set --local ext

  if set --query _flag_multi
    set ext (string split '.' $argv[1] --no-empty --max 1 --fields 2)
    or begin
      printf "Error: '%s' is not valid\n" $argv[1] >&2
      return 1
    end
  else
    set ext (string match --regex --groups-only '^\.?[\w,\s-]+(\.[A-Za-z]+)+$' $argv[1] | string split '.' --fields 2)
    or begin
      printf "Error: '%s' is not valid\n" $argv[1] >&2
      return 1
    end
  end

  if set --query _flag_lower
    string lower $ext
  else if set --query _flag_upper
    string upper $ext
  else
    echo $ext
  end
end
