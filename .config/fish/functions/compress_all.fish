function compress_all --description "Compress a variety of file types"
  function __help
    echo "Reduces the size of the given files if possible. Currently supports JPG, PNG, and PDF."
    echo ""
    echo "Usage: "(status current-command)" [file ...] [options]"
    echo ""
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
        compress_jpg $args
      case 'pdf'
        compress_pdf $args
      case 'png'
        compress_png $args
      case '*'
        echo "Error: Compression not supported for $file" >&2
        return 1
    end
  else
    for file in $argv
      switch (extension --lower $file)
        case 'jpg' 'jpeg'
          compress_jpg $file
        case 'pdf'
          compress_pdf $file
        case 'png'
          compress_png $file
        case '*'
          echo "Error: Compression not supported for $file" >&2
          return 1
      end
      echo "Compressed $file"
    end
  end
end
