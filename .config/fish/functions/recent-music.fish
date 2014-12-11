function recent-music --description "Plays all songs in ~/Music, sorted by recent music first"
  pushd ~/Music
  mplayer -quiet (ls -t **.{mp3,m4a}) | sed -n -e 's/Playing //p'
  popd
end
