function compress_all -d "Compress a variety of file types"
  function __help
    echo "Reduces the size of the given files if possible. Currently supports JPG, PNG, and PDF."
    echo ""
    echo "Usage: "(status current-command)" [file ...] [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message and exit"
    echo "  -o, --output   Output to given path (instead of overwriting existing file), limited to one input"
    echo "  -s, --silent   Suppress compression statistics (verbose by default)"
    echo "  -t, --trace    Enable fish trace mode for debugging"
  end

  set --local options 'h/help' 'o/output=' 's/silent' 't/trace'
  argparse $options -- $argv; or return

  if set --query _flag_trace; set --local fish_trace 1; end
  set --local argc (count $argv)

  if set --query _flag_help; or test $argc -eq 0
    __help; return 0
  end

  set -l pass_flags
  if set --query _flag_silent; set -a pass_flags -s; end
  if set --query _flag_trace;  set -a pass_flags -t; end

  if set --query _flag_output
    if test $argc -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end

    switch (extension --lower -- $argv[1] 2>/dev/null)
      case jpg jpeg
        compress_jpg $pass_flags -o $_flag_output -- $argv[1]
      case png
        compress_png $pass_flags -o $_flag_output -- $argv[1]
      case pdf
        compress_pdf $pass_flags -o $_flag_output -- $argv[1]
      case '*'
        echo "Error: Compression not supported for '$argv[1]'" >&2
        return 1
    end
  else
    set -l had_error 0
    for file in $argv
      switch (extension --lower -- $file 2>/dev/null)
        case jpg jpeg
          compress_jpg $pass_flags -- $file; or set had_error 1
        case png
          compress_png $pass_flags -- $file; or set had_error 1
        case pdf
          compress_pdf $pass_flags -- $file; or set had_error 1
        case '*'
          echo "Error: Compression not supported for '$file'" >&2
          set had_error 1
      end
    end
    return $had_error
  end
end
