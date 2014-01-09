function play-music --description "Plays all music in ~/Music then terminates"
  exec mplayer -msgcolor -shuffle -quiet ~/Music/** ^/dev/null
end
