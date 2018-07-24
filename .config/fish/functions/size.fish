function size --description "Human readable size of the given file/dir"
  ls -gh $argv[1] | awk '{ printf("%-20s %5s\n", $8, $4) }'

  # du -chd 1 $argv[1] | grep total | cut -f 1
  #
  # BSD tools don't have long options --total --human-readable --max-depth=1
  #
  # du doesn't give the size of the file, it gives an indication of how much
  # space the file uses, which is subtly different (usually the size reported by
  # du is the size of the file rounded up to the nearest number of blocks, where
  # a block is typically 512B or 1kB or 4kB)
end
