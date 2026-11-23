function __compress_print_stats -d "Print compression statistics" -a input_file orig_size final_size method
  if test "$method" = "none"; or test -z "$orig_size"; or test "$orig_size" -le 0
    printf "'%s' could not be compressed further - already optimal size\n" (basename -- $input_file)
    return 0
  end

  set -l reduction_pct (math -s0 "100 - ($final_size * 100 / $orig_size)")
  set -l orig_size_kb (math -s1 "$orig_size / 1024")
  set -l final_size_kb (math -s1 "$final_size / 1024")
  set -l orig_size_mb (math -s1 "$orig_size / 1024 / 1024")
  set -l final_size_mb (math -s1 "$final_size / 1024 / 1024")

  set -l one_mb 1048576
  set -l orig_size_decorated
  set -l final_size_decorated

  # Show reduction in MB unless original size is small or reduction is tiny.
  if test $orig_size -gt $one_mb -a "$orig_size_mb" != "$final_size_mb"
    set orig_size_decorated $orig_size_mb"MB"
    set final_size_decorated $final_size_mb"MB"
  else
    set orig_size_decorated $orig_size_kb"KB"
    set final_size_decorated $final_size_kb"KB"
  end

  printf "'%s' compressed with %s: %d%% reduction (%s → %s)\n" \
    (basename -- $input_file) $method $reduction_pct $orig_size_decorated $final_size_decorated
end
