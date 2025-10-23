function gif2frames  --description "Splits a gif into png frames"
  for gif in $argv
    magick $gif -coalesce (basename $gif .gif)-%02d.png
  end
end
