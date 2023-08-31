# Collection of compression helper functions for a variety of file types.

function pngcompress -d "Reduce PNG file size"
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
  function __help
    echo "Usage: comprss [file ...] [options]"
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo "  -o, --output  Output to given path (instead of overwriting existing file). Limits input to single file"
  end

  set --local args $argv # Because argparse mutates $argv
  set --local options 'h/help' 'o/output='
  argparse --max-args=2 $options -- $argv
  or return

  if set --query _flag_help
    __help
    return 0
  end

  if set --query _flag_output
    if test (count $argv) -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end

    switch (string lower (extension $argv[1]))
      case 'png'
        pngcompress $args
      case '*'
        echo "Error: Filetype unsupported" >&2
        return 1
    end
  else
    for file in $argv
      switch (string lower (extension $file))
        case 'png'
          pngcompress $file
        case '*'
          echo "Error: Filetype unsupported for $file" >&2
          return 1
      end
      echo "Compressed $file"
    end
  end
end