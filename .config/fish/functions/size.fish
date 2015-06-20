function size --description "Human readable size of the given file/dir"
  du -chd 1 $argv[1] | grep total | cut -f 1
  # BSD tools don't have long options --total --human-readable --max-depth=1
end
