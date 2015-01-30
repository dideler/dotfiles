function filename -d "Returns the filename part before the extension"
  # Assumes the extension succeeds the last dot.
  echo (basename $argv[1] .(extension $argv[1]))
end
