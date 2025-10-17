function compress_pdf -d "Reduce PDF file size"
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
    set -l file $argv[1]

    test -f $file \
      && string match -q -- '*.pdf' -- (string lower (basename -- $file)) \
      && string match -q -- 'application/pdf' -- (file --mime-type --brief -- $file) \
      && return 0

    echo "Error: '$file' is not a valid PDF file" >&2
    return 1
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

alias pdfcompress compress_pdf
