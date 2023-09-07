# Collection of compression helper functions for a variety of file types.

function pdfcompress -d "Reduce PDF file size"
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
    string match -q '*.pdf' (string lower $argv[1]) && \
    string match -rq "^$argv[1]: PDF document" (file $argv[1])
    or echo "Error: '$argv[1]' is not a valid PDF file" >&2
    and return 1
  end

  if set --query _flag_output
    if test $argc -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end

    __validate! $argv[1] or return
    ps2pdf -dPDFSETTING=/ebook $argv[1] $_flag_output
  else
    for file in $argv
      __validate! $file or continue
      set --local temp_file (mktemp) # Have to use a temp swap file because ps2pdf has no overwrite option
      ps2pdf -dPDFSETTING=/ebook $file $temp_file
      mv $temp_file $file
    end
  end
end

function jpgcompress -d "Reduce JPG file size"
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

function pngcompress -d "Reduce PNG file size"
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
    string match -q '*.png' (string lower $argv[1]) && \
    string match -rq "^$argv[1]: PNG image data" (file $argv[1])
    or echo "Error: '$argv[1]' is not a valid PNG file" >&2
    and return 1
  end

  if set --query _flag_output
    if test $argc -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end

    __validate! $argv[1] or return
    pngquant --speed=1 --output $_flag_output $argv[1]
  else
    for file in $argv
      __validate! $file or continue
      pngquant --speed=1 --ext ".png" --force $file
    end
  end
end

function comprss --description "Compress a variety of file types" # The name 'compress' is taken by a BSD tool.
  function __help
    echo "Usage: "(status current-command)" [file ...] [options]"
    echo "Options:"
    echo "  -h, --help    Show this help message and exit"
    echo "  -o, --output  Output to given path (instead of overwriting existing file). Limits input to single file"
  end

  set --local args $argv # Because argparse mutates $argv
  set --local options 'h/help' 'o/output='
  argparse $options -- $argv
  or return

  set --local argc (count $argv)

  if set --query _flag_help
  or test $argc -eq 0
    __help
    return 0
  end

  if set --query _flag_output
    if test $argc -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end

    switch (extension --lower $argv[1])
      case 'jpg' 'jpeg'
        jpgcompress $args
      case 'pdf'
        pdfcompress $args
      case 'png'
        pngcompress $args
      case '*'
        echo "Error: Filetype unsupported" >&2
        return 1
    end
  else
    for file in $argv
      switch (extension --lower $file)
        case 'jpg' 'jpeg'
          jpgcompress $file
        case 'pdf'
          pdfcompress $file
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
