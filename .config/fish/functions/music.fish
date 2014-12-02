function music --description "Plays all music in ~/Music then terminates"
  exec mplayer -msgcolor -shuffle -quiet ~/Music/**.mp3 ^/dev/null
end
