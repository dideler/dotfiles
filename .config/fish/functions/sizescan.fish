function sizescan --description "Full-disk size scan using ncdu"
  # exclude macOS firmlinks, which are not supported by ncdu
  ncdu --exclude /System/Volumes/Data -x /
end
