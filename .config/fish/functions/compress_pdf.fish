# Depends on https://github.com/americanhanko/fish-spin, ps2pdf, ghostscript, and ImageMagick

function __pdf_print_stats -d "Print compression statistics" -a input_file orig_size final_size method
  set -l orig_size_decorated
  set -l final_size_decorated
  set -l reduction_pct (math -s0 "100 - ($final_size * 100 / $orig_size)")

  if test "$method" = "none"
    echo "'$input_file' could not be compressed further - already optimal size"
  else
    set -l orig_size_kb (math -s1 "$orig_size / 1024")
    set -l final_size_kb (math -s1 "$final_size / 1024")

    set -l orig_size_mb (math -s1 "$orig_size / 1024 / 1024")
    set -l final_size_mb (math -s1 "$final_size / 1024 / 1024")

    set -l one_mb 1048576

    # Show reduction in MB unless original size is small or reduction is tiny.
    if test $orig_size -gt $one_mb -a "$orig_size_mb" != "$final_size_mb"
      set orig_size_decorated $orig_size_mb"MB"
      set final_size_decorated $final_size_mb"MB"
    else
      set orig_size_decorated $orig_size_kb"KB"
      set final_size_decorated $final_size_kb"KB"
    end

    printf "'%s' compressed with %s: %d%% reduction (%s → %s)\n" \
      $input_file $method $reduction_pct $orig_size_decorated $final_size_decorated
  end
end

function __pdf_get_smallest -d "Compress using different methods and return the path to the smallest file" -a input
  set -l orig_size (file_size_bytes $input)
  set -l temps
  set -l sizes
  set -l methods

  function __try_ps2pdf -a input
    set -l temp (mktemp)
    if command ps2pdf -dPDFSETTINGS=/ebook $input $temp >/dev/null 2>&1; and test -s $temp
      echo $temp
    else
      rm -f $temp
    end
  end

  function __try_gs -a input
    set -l temp (mktemp)
    if command gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$temp $input >/dev/null 2>&1; and test -s $temp
      echo $temp
    else
      rm -f $temp
    end
  end

  function __try_magick -a input
    set -l temp (mktemp)
    if command magick -density 300 -quality 30 $input $temp >/dev/null 2>&1; and test -s $temp
      echo $temp
    else
      rm -f $temp
    end
  end

  set -l temp (__try_ps2pdf $input)
  if test -n "$temp"
    set -a temps $temp
    set -a sizes (file_size_bytes $temp)
    set -a methods "ps2pdf"
  end

  set -l temp (__try_gs $input)
  if test -n "$temp"
    set -a temps $temp
    set -a sizes (file_size_bytes $temp)
    set -a methods "gs"
  end

  set -l temp (__try_magick $input)
  if test -n "$temp"
    set -a temps $temp
    set -a sizes (file_size_bytes $temp)
    set -a methods "imagemagick"
  end

  if test (count $sizes) -eq 0
    echo $input; echo "none"; echo $orig_size; return 0
  end

  set -l min_size $sizes[1]
  set -l min_idx 1
  for i in (seq 2 (count $sizes))
    if test $sizes[$i] -lt $min_size
      set min_size $sizes[$i]
      set min_idx $i
    end
  end

  if test $min_size -ge $orig_size
    for temp in $temps; rm $temp; end
    echo $input; echo "none"; echo $orig_size; return 0
  end

  set -l best $temps[$min_idx]
  for i in (seq (count $temps))
    if test $i -ne $min_idx; rm $temps[$i]; end
  end
  echo $best; echo $methods[$min_idx]; echo $min_size
end

function __pdf_do_compress -d "Worker function for compression" -a input output_path silent
  validate_pdf $input; or return 1

  set -l orig_size (file_size_bytes $input)
  set -l result (__pdf_get_smallest $input)
  set -l best $result[1]
  set -l method $result[2]
  set -l final_size $result[3]

  if test "$best" != "$input"
    mv "$best" "$output_path"
  else if test "$output_path" != "$input"
    cp "$input" "$output_path"
  end

  if test "$silent" != "1"
    __pdf_print_stats $input $orig_size $final_size $method
  end
end

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

  # FIXME: Cannot use spinner with a fish function, 'unknown command' error.
  # Spinner runs the command in a subshell, so the function is not found
  # because it's not inherited, or an executable in PATH, or a file in
  # `~/.config/fish/functions/`. We get around this by sourcing the current
  # function file again in the spinner command, but this is a bit of a hack.
  #
  # If we keep the spinner, consider moving the worker function to its own
  # file like `~/.config/fish/functions/__pdf_do_compress.fish`.
  # set -l script (status current-filename)
  set -l safe_script (string escape -- (status current-filename))

  set -l clear_line "\r\033[K"

  if set --query _flag_output
    if test $argc -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end

    set -l safe_input  (string escape -- $argv[1])
    set -l safe_output (string escape -- $_flag_output)
    set -l cmd "source $safe_script; __pdf_do_compress $safe_input $safe_output $silent"
    spin --interval=100 "$cmd" && printf $clear_line
  else
    for input in $argv
      set -l safe_path (string escape -- $input)
      set -l cmd "source $safe_script; __pdf_do_compress $safe_path $safe_path $silent"
      spin --interval=100 "$cmd" && printf $clear_line; or continue
    end
  end
end

alias pdfcompress compress_pdf
