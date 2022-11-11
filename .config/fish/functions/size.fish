function size --description "Human readable size of the given file/dir"
  for file in $argv
    # TODO: Handle files with whitespace by not breaking them apart
    if test -e $file
      ls -ghS $file | awk '{ printf("%-10s %5s\n", $4, $8) }'
    else
      echo "Error: Not a valid file" >&2
    end
  end
  # Or: ncdu -o-
  # Note: Accurate and handles whitespace but need to parse JSON and convert bytes to human readable (with numfmt for example)
  #
  # Or: du -chd 1 $argv[1]
  # Note: Doesn't give the actual size of the file, it gives an indication
  #       of how much space the file uses, rounded up to the nearest block,
  #       where a block is typically 512B or 1kB or 4kB.
end
