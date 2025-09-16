function jpg2pdf --description "Convert JPG images to PDF using sips, ImageMagick, or img2pdf"
  function __help
    echo "Usage: jpg2pdf [options] input1.jpg [input2.jpg ...]"
    echo ""
    echo "Options:"
    echo "  -m, --method   Conversion method: auto|sips|imagemagick|img2pdf (default: auto)"
    echo "  -o, --output   Output PDF file name (default: first input name with .pdf)"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Multiple JPGs are merged into a single PDF (only supported with img2pdf or imagemagick)."
  end

  set --local options 'h/help' 'm/method=' 'o/output='
  argparse $options -- $argv
  or return

  set --local argc (count $argv)

  if set --query _flag_help
  or test $argc -eq 0
    __help
    return 0
  end

  set method "auto"
  set output ""

  if set -q _flag_method
    set method $_flag_m
  end

  if set -q _flag_output
    set output $_flag_o
  end

  set input_files $argv

  if test $method = "auto"
    if type -q img2pdf
      set method "img2pdf"
    else
      set method "sips"
    end
  end

  if test -z $output
    set output (basename $input_files[1] .jpg).pdf
  end

  switch $method
    case "sips"
      if test (count $input_files) -gt 1
        echo "Error: sips only supports a single input file." >&2
        return 1
      end
      sips -s format pdf $input_files[1] --out $output

    case "imagemagick"
      convert $input_files $output

    case "img2pdf"
      img2pdf $input_files -o $output

    case '*'
      echo "Error: Unknown method '$method'" >&2
      return 1
  end

  echo "Converted to $output using $method"
end
