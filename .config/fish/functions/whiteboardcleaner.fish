# Depends on https://github.com/americanhanko/fish-spin and IMv7

function whiteboardcleaner --description "Converts whiteboard writing to a clean image"
  function __help
    echo "Cleans whiteboard images by enhancing contrast and removing glare"
    echo
    echo "Usage: "(status current-command)" [OPTIONS] FILE..."
    echo
    echo "Options:"
    echo "  -h, --help          Show this help message and exit"
    echo "  -o, --output FILE   Output to given path instead of overwriting existing file"
    echo "                      Limits input to single file"
  end

  set --local options 'h/help' 'o/output='
  argparse $options -- $argv
  or return

  set --local argc (count $argv)

  if set --query _flag_help
  or test $argc -eq 0
    __help
    return
  end

  # Original args by @lelandbatey at https://gist.github.com/lelandbatey/8677901
  # Updated args by @santhalakshminarayana & @mostafatouny
  set --local cmd_args \
    -morphology Convolve DoG:15,100,0 \
    -negate \
    -contrast-stretch 2%x0.5% \
    -blur 0x1 \
    -gamma 1.1 \
    -channel RBG -level 2%,98%

  set --local clear_line "\r\033[K"

  if set --query _flag_output
    if test $argc -gt 1
      echo "Error: -o/--output option requires a single input file" >&2
      return 1
    end
    spin --interval=100 --spinner=clock "magick $argv[1] $cmd_args $_flag_output" && printf $clear_line
  else
    for file in $argv
      spin --interval=100 --spinner=clock "magick $file $cmd_args $file"
      if test $argc -gt 1
        echo "Processed '$file'"
      else
        printf $clear_line
      end
    end
  end
end
