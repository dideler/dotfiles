function compress_pdf -d "Reduce PDF file size"
  function __help
    echo "Usage: "(status current-command)" [file ...] [options]"
    echo "Options:"
    echo "  -h, --help     Show this help message and exit"
    echo "  -o, --output   Output to given path (instead of overwriting existing file). Limits input to single file"
    echo "  -v, --verbose  Show compression statistics"
    echo "  -t, --trace    Enable fish trace mode for debugging"
  end

  set --local options 'h/help' 'o/output=' 'v/verbose' 't/trace'
  argparse $options -- $argv
  or return

  if set --query _flag_trace
    set --local fish_trace 1
  end

  set --local argc (count $argv)

  if set --query _flag_help
  or test $argc -eq 0
    __help
    return 0
  end

  function size_bytes -d "Get file size in bytes" -a file
    if test (uname) = "Darwin"
      stat -f%z $file  # macOS
    else
      stat -c%s $file  # Linux
    end
  end

  function __validate! -d "Validate file existence, extension, and type" -a file

    test -f $file \
      && string match -q -- '*.pdf' -- (string lower (basename -- $file)) \
      && string match -q -- 'application/pdf' -- (file --mime-type --brief -- $file) \
      && return 0

    echo "Error: '$file' is not a valid PDF file" >&2
    return 1
  end

  function __get_smallest -d "Compress using different methods and return the path to the smallest file" -a input
    set -l orig_size (size_bytes $input)
    set -l temps
    set -l sizes

    function __try_ps2pdf -d "Try compressing with ps2pdf" -a input
      set -l temp (mktemp)
      if command ps2pdf -dPDFSETTINGS=/ebook $input $temp >/dev/null 2>&1; and test -s $temp
        echo $temp
      else
        rm -f $temp
      end
    end

    function __try_gs -d "Try compressing with ghostscript" -a input
      set -l temp (mktemp)
      if command gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=$temp $input >/dev/null 2>&1; and test -s $temp
        echo $temp
      else
        rm -f $temp
      end
    end

    function __try_magick -d "Try compressing with ImageMagick" -a input
      set -l temp (mktemp)
      if command magick -density 300 -quality 30 $input $temp >/dev/null 2>&1; and test -s $temp
        echo $temp
      else
        rm -f $temp
      end
    end

    function __select_smallest -d "Select the smallest file from temps and sizes" -a input orig_size
      # Algorithm:
      # 1. If no compression methods succeeded (sizes array empty), return original input file
      # 2. Find the smallest compressed file by comparing all sizes
      # 3. If smallest compressed size >= original size, delete all temps and return original
      # 4. Otherwise, keep the smallest compressed file, delete the rest, and return its path
      #
      # Arguments: input orig_size temps[1] temps[2] ... -- sizes[1] sizes[2] ... -- methods[1] methods[2] ...
      # Returns 3 lines: best_file, method_name, final_size

      # $argv contains all arguments including the named ones ($input, $orig_size)
      # Parse: temps -- sizes -- methods (skip first 2 which are named args)
      set -l remaining $argv[3..-1]

      # Find first "--" separator
      set -l first_sep (contains -i -- "--" $remaining)
      set -l temps $remaining[1..(math $first_sep - 1)]

      # Find second "--" separator in what's left after first
      set -l after_first $remaining[(math $first_sep + 1)..-1]
      set -l second_sep (contains -i -- "--" $after_first)
      set -l sizes $after_first[1..(math $second_sep - 1)]
      set -l methods $after_first[(math $second_sep + 1)..-1]

      if test (count $sizes) -eq 0
        echo $input
        echo "none"
        echo $orig_size
        return 0
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
        for temp in $temps
          rm $temp
        end
        echo $input
        echo "none"
        echo $orig_size
        return 0
      end

      set -l best $temps[$min_idx]
      for i in (seq (count $temps))
        if test $i -ne $min_idx
          rm $temps[$i]
        end
      end
      echo $best
      echo $methods[$min_idx]
      echo $min_size

      # TODO: If no meaningful difference in size, tell user to scan file with Dropbox? Usually decreases size significantly.
    end

    set -l methods
    set -l temp (__try_ps2pdf $input)
    if test -n "$temp"
      set -a temps $temp
      set -a sizes (size_bytes $temp)
      set -a methods "ps2pdf"
    end

    set -l temp (__try_gs $input)
    if test -n "$temp"
      set -a temps $temp
      set -a sizes (size_bytes $temp)
      set -a methods "gs"
    end

    set -l temp (__try_magick $input)
    if test -n "$temp"
      set -a temps $temp
      set -a sizes (size_bytes $temp)
      set -a methods "imagemagick"
    end

    set -l result (__select_smallest $input $orig_size $temps -- $sizes -- $methods)
    # Return all three values: file path, method, size
    echo $result[1]
    echo $result[2]
    echo $result[3]
  end

  function __print_stats -d "Print compression statistics" -a input_file orig_size final_size method
    # Convert bytes to human-readable format
    set -l orig_mb (math $orig_size / 1024 / 1024)
    set -l final_mb (math $final_size / 1024 / 1024)
    set -l reduction (math -s0 "100 - ($final_size * 100 / $orig_size)")  # -s0 rounds to integer

    if test "$method" = "none"
      echo "No compression - file already optimal"
    else
      printf "%s: %d%% reduction (%0.1fMB → %0.1fMB)\n" $method $reduction $orig_mb $final_mb
    end
  end

  if set --query _flag_output
    if test $argc -gt 1
      echo "Error: Only one input file is allowed when using the -o/--output option" >&2
      return 1
    end
    set -l input $argv[1]
    __validate! $input; or return 1
    set -l orig_size (size_bytes $input)
    set -l result (__get_smallest $input)
    set -l best $result[1]
    set -l method $result[2]
    set -l final_size $result[3]

    if test $best = $input
      cp $input $_flag_output
    else
      mv $best $_flag_output
    end

    if set --query _flag_verbose
      __print_stats $input $orig_size $final_size $method
    end
  else
    for file in $argv
      __validate! $file; or continue
      set -l orig_size (size_bytes $file)
      set -l result (__get_smallest $file)
      set -l best $result[1]
      set -l method $result[2]
      set -l final_size $result[3]

      if test $best != $file
        mv $best $file
      end

      if set --query _flag_verbose
        __print_stats $file $orig_size $final_size $method
      end
    end
  end
end

alias pdfcompress compress_pdf
