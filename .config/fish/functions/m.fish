function m --description "Silently plays the given audio files at 75% volume"
  mplayer -really-quiet -volume 75 $argv 2>/dev/null
end
