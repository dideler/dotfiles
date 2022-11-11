function pdfcompress -d "Shrink PDF size"
  function _pdfcompress_help
    echo "Usage: pdfcompress input.pdf [output.pdf]"
  end

  set --local options 'h/help'
  argparse --max-args=2 $options -- $argv
  or return

  if set --query _flag_help
    _pdfcompress_help
    return 0
  end

  function __pdfcompress_validate!
    test -f $argv[1] && \
    test (string lower (extension $argv[1])) = 'pdf' && \
    string match -rq "^$argv[1]: PDF document" (file $argv[1])
    or echo "Error: Not a valid file" >&2 && return 1
  end

  # Methods derived from https://askubuntu.com/questions/113544/how-can-i-reduce-the-file-size-of-a-scanned-pdf-file
  function _pdfcompress_call!
    ps2pdf -dPDFSETTING=/ebook $argv[1] $argv[2]
  end

  switch (count $argv)
    case 0
      _pdfcompress_help >&2; return 1
    case 1
      set --local in_file $argv[1]
      set --local out_file "$in_file.pdf"
      __pdfcompress_validate! $in_file
      _pdfcompress_call! $in_file $out_file
    case 2
      set --local in_file $argv[1]
      set --local out_file $argv[2]
      __pdfcompress_validate! $in_file
      _pdfcompress_call! $in_file $out_file
  end
end

function pngcompress -d "Reduce size of PNG files given or all PNG files in current directory"
  # TODO: handle args
  pngquant --skip-if-larger --speed=1 --ext .png --force **.png
end

function jpgcompress -d "Reduce size of JPG files given or all JPG files in current directory"
  # TODO: handle args
  find . -name '*.jpg' -type f -print | xargs -I@ jpegtran -copy none -optimize -outfile @ @
end

function compress --description "Compress a variety of file types"
  # TODO: handle args
  # TODO: create specific compression functions that 'compress' delegates to based on filetype
end
