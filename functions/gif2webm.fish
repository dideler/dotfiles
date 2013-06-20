# Converts a gif to still frames, converts those to webm, then deletes frames.
function gif2webm
  echo converting...
  for gif in $argv
    gif2frames $gif
    avconv -loglevel quiet -f image2 -r 30 -i (basename $gif .gif)-%02d.png \
           -vcodec libvpx -b 1M -crf 5 -y (basename $gif .gif).webm
    rm (basename $gif .gif)-*.png
  end
end
