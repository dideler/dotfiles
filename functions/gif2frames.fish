function gif2frames
  for gif in $argv
    convert $gif -coalesce (basename $gif .gif)-%02d.png
  end
end
