function compress_jpg -d "Reduce JPG file size"
  function __help
    echo "Usage: "(status current-command)" [file ...] [options]"
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo "  -o, --output  Output to given path (instead of overwriting existing file). Limits input to single file"
  end

  set --local options 'h/help' 'o/output='
  argparse $options -- $argv
  or return

  set --local argc (count $argv)

  if set --query _flag_help
  or test $argc -eq 0
    __help
    return 0
  end

  function __validate! -d "Validate file existence, extension, and type"
    test -f $argv[1] && \
    string match -q '*.jpg' (string lower $argv[1]) || \
    string match -q '*.jpeg' (string lower $argv[1]) && \
    string match -rq "^$argv[1]: JPEG image data" (file $argv[1])
    or echo "Error: '$argv[1]' is not a valid JPEG file" >&2
    and return 1
  end

  if set --query _flag_output
    if test $argc -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end

    __validate! $argv[1] or return
    jpegtran -copy none -optimize -progressive -outfile $_flag_output $argv[1]
  else
    for file in $argv
      __validate! $file or continue
      jpegtran -copy none -optimize -progressive -outfile $argv[1] $argv[1]
    end
  end
end

alias jpgcompress compress_jpg
