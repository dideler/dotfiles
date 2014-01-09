function m --description "Silently plays the given audio files"
  mplayer -really-quiet $argv ^/dev/null
end
