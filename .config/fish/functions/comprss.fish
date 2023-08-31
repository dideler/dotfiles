# Collection of compression helper functions for a variety of file types.

function pngcompress -d "Reduce size of PNG files given or all PNG files in current directory"
  function __help
    echo "Usage: pngcompress [file ...] [options]"
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo "  -o, --output  Output to given path (instead of overwriting existing file). Limits input to single file"
  end

  set --local options 'h/help' 'o/output='
  argparse --max-args=2 $options -- $argv
  or return

  if set --query _flag_help
    __help
    return 0
  end

  function __validate! -d "Validate file existence, extension, and type"
    test -f $argv[1] && \
    string match -q '*.png' (string lower $argv[1]) && \
    string match -rq "^$argv[1]: PNG image data" (file $argv[1])
    or echo "Error: File '$argv[1]' does not exist or is not a PNG file" >&2
    and return 1
  end

  if set --query _flag_output
    if test (count $argv) -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end

    __validate! $argv[1] or return
    pngquant --skip-if-larger --speed=1 --output $_flag_output $argv[1]
  else
    for file in $argv
      __validate! $file or continue
      pngquant --skip-if-larger --speed=1 --ext ".png" --force $file
    end
  end
end

function comprss --description "Compress a variety of file types" # The name 'compress' is taken by a BSD tool.
  # TODO: create specific compression functions to delegate to based on filetype
end
