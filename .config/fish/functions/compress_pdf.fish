# Depends on https://github.com/americanhanko/fish-spin, ps2pdf, ghostscript, and ImageMagick
# and `.config/fish/functions/{__pdf_compress,file_size_bytes,validate_pdf}.fish`

# TODO: Create a fish plugin repo for all compress functions and helper functions.
#       It's gotten quite big. Also can specify dependencies better via a fishfile.

function compress_pdf -d "Reduce PDF file size"
  function __help
    echo "Usage: "(status current-command)" [file ...] [options]"
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

  set -l silent 0
  if set --query _flag_silent; set silent 1; end

  set -l clear_line "\r\033[K"

  if set --query _flag_output
    if test $argc -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end

    set -l safe_input  (string escape -- $argv[1])
    set -l safe_output (string escape -- $_flag_output)
    set -l cmd "__pdf_compress $safe_input $safe_output $silent"
    spin --interval=100 "$cmd" && printf $clear_line
  else
    for input in $argv
      set -l safe_path (string escape -- $input)
      set -l cmd "__pdf_compress $safe_path $safe_path $silent"
      spin --interval=100 "$cmd" && printf $clear_line; or continue
    end
  end
end

alias pdfcompress compress_pdf
