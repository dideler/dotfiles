function sizescan --description "Full-disk size scan using ncdu"
  # exclude macOS firmlinks, which are not supported by ncdu
  ncdu --one-file-system --exclude /System/Volumes/Data /
end
