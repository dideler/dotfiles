# Usage
#
#   pdf2jpg in.pdf  # => in.jpg
#
#   pdf2jpg in.pdf out.jpg  # => out.jpg
#
function pdf2jpg --description "Convert a (scanned) PDF to a JPG"

  function _print_usage
    echo -e "Usage:\n  pdf2jpg in.pdf\n  pdf2jpg in.pdf out.jpg"
  end

  switch (count $argv)
    case 0  # No arguments, error.
      _print_usage
      return 1

    case 1  # One argument.
      switch $argv
        case '-h' '--h' '--he' '--hel' '--help'
          _print_usage
          return 0

        case '-*'
          printf "%s: Unknown option %s\n" pdf2jpg $argv
          return 1

        case '*.pdf' '*.PDF'
          set pdf $argv[1]

        case '*'
          _print_usage
          return 1
      end

    case 2  # Two arguments.
      switch (echo $argv)
        case '*.pdf *.jpg' '*.pdf *.jpeg' '*.PDF *.jpg' '*.PDF *.jpeg'
          set pdf $argv[1]
          set jpg $argv[2]

        case '*'
          _print_usage
          return 1
      end

    case \*  # Too many arguments, error.
      printf "%s: Expected one or two arguments, got %d\n" pdf2jpg (count $argv)
      return 1
  end

  if not set --query jpg
    set jpg (filename $pdf).jpg  # Use the filename of the PDF for the JPG.
  end

  convert -quiet -density 150 -trim $pdf -quality 100 -sharpen 0x1.0 $jpg
end
